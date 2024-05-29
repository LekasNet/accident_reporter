const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const pool = require('../config/dbConfig');
const router = express.Router();

// Регистрация водителя
router.post('/register', async (req, res) => {
    const {login, password, phone, full_name, driving_experience, driver_license} = req.body;

    try {
        const phoneCheckQuery = 'SELECT * FROM driver WHERE phone = $1';
        const phoneCheckResult = await pool.query(phoneCheckQuery, [phone]);

        if (phoneCheckResult.rows.length > 0) {
            return res.status(400).json({message: 'Phone number already exists'});
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const query = 'INSERT INTO driver (login, password, phone, full_name, driving_experience, driver_license) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *';
        const values = [login, hashedPassword, phone, full_name, driving_experience, driver_license];
        await pool.query(query, values);
        res.status(201).json({message: 'Driver registered successfully'});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error registering driver'});
    }
});

// Логин водителя
router.post('/login', async (req, res) => {
    const {login, password} = req.body;

    try {
        const query = 'SELECT * FROM driver WHERE login = $1';
        const result = await pool.query(query, [login]);

        if (result.rows.length === 0) {
            return res.status(401).json({message: 'Invalid login credentials'});
        }

        const driver = result.rows[0];
        const passwordMatch = await bcrypt.compare(password, driver.password);

        if (!passwordMatch) {
            return res.status(401).json({message: 'Invalid login credentials'});
        }

        const accessToken = jwt.sign({
            id: driver.id,
            login: driver.login
        }, process.env.JWT_ACCESS_SECRET, {expiresIn: '30m'});
        const refreshToken = jwt.sign({
            id: driver.id,
            login: driver.login
        }, process.env.JWT_REFRESH_SECRET, {expiresIn: '7d'});

        res.status(200).json({message: 'Login successful', accessToken, refreshToken});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error logging in'});
    }
});

// Добавление информации об автомобиле
router.post('/add-vehicle', async (req, res) => {
    const {brand, model, body_type, reg_number} = req.body;
    const token = req.headers.authorization;

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_SECRET);

        const query = 'INSERT INTO vehicle (brand, model, body_type, reg_number) VALUES ($1, $2, $3, $4) RETURNING *';
        const values = [brand, model, body_type, reg_number];

        const result = await pool.query(query, values);

        const vehicleId = result.rows[0].id;
        const driverId = decodedToken.id;

        const driverVehicleQuery = 'INSERT INTO driver_vehicle (driver_id, vehicle_id) VALUES ($1, $2)';
        const driverVehicleValues = [driverId, vehicleId];

        await pool.query(driverVehicleQuery, driverVehicleValues);

        res.status(201).json({message: 'Vehicle added successfully'});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error adding vehicle'});
    }
});

// Удаление информации об автомобиле
router.delete('/delete-vehicle/:vehicleId', async (req, res) => {
    const vehicleId = req.params.vehicleId;
    const token = req.headers.authorization;

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_SECRET);

        const driverId = decodedToken.id;

        const checkQuery = 'SELECT * FROM driver_vehicle WHERE driver_id = $1 AND vehicle_id = $2';
        const checkValues = [driverId, vehicleId];
        const checkResult = await pool.query(checkQuery, checkValues);

        if (checkResult.rows.length === 0) {
            return res.status(403).json({message: 'You do not have permission to delete this vehicle'});
        }

        const deleteQuery = 'DELETE FROM driver_vehicle WHERE driver_id = $1 AND vehicle_id = $2';
        await pool.query(deleteQuery, checkValues);

        const deleteVehicleQuery = 'DELETE FROM vehicle WHERE id = $1';
        await pool.query(deleteVehicleQuery, [vehicleId]);

        res.status(200).json({message: 'Vehicle deleted successfully'});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error deleting vehicle'});
    }
});

// Получение информации об автомобилях водителя
router.get('/vehicles', async (req, res) => {
    const token = req.headers.authorization;

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_SECRET);

        const query = 'SELECT v.* FROM vehicle v INNER JOIN driver_vehicle dv ON v.id = dv.vehicle_id WHERE dv.driver_id = $1';
        const values = [decodedToken.id];

        const result = await pool.query(query, values);

        res.status(200).json({message: 'Vehicles retrieved successfully', data: result.rows});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving vehicles'});
    }
});

// Добавление информации о ДТП
router.post('/add-accident', async (req, res) => {
    const {report_number, date, location, accident_type, accident_cause, casualties, participants} = req.body;
    const token = req.headers.authorization;

    try {
        jwt.verify(token, process.env.JWT_ACCESS_SECRET);
        const accidentQuery = 'INSERT INTO accident (report_number, date, location, accident_type, accident_cause, casualties) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id';
        const accidentValues = [report_number, date, location, accident_type, accident_cause, casualties];

        const accidentResult = await pool.query(accidentQuery, accidentValues);
        const accidentId = accidentResult.rows[0].id;

        const participantsQuery = 'INSERT INTO accident_participant (accident_id, participant_driver_license, participant_vehicle_reg_number) VALUES ($1, $2, $3)';

        await pool.query('BEGIN');
        for (const participant of participants) {
            const participantValues = [accidentId, participant.driver_license, participant.vehicle_reg_number];
            try {
                await pool.query(participantsQuery, participantValues);
            } catch (participantError) {
                console.error(`Error adding participant: ${participant.driver_license}`, participantError);
                throw participantError;
            }
        }
        await pool.query('COMMIT');

        res.status(201).json({message: 'Accident information added successfully', accidentId});
    } catch (error) {
        await pool.query('ROLLBACK');
        console.error(error);
        res.status(500).json({message: 'Error adding accident information'});
    }
});

// Автоматическое добавление информации о ДТП при столкновении
router.post('/add-accident-auto', async (req, res) => {
    const {report_number, date, location, accident_type, accident_cause, casualties} = req.body;
    const token = req.headers.authorization;

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_SECRET);

        const accidentQuery = 'INSERT INTO accident (report_number, date, location, accident_type, accident_cause, casualties) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id';
        const accidentValues = [report_number, date, location, accident_type, accident_cause, casualties];

        const accidentResult = await pool.query(accidentQuery, accidentValues);
        const accidentId = accidentResult.rows[0].id;

        const driverQuery = 'SELECT driver_license FROM driver WHERE id = $1';
        const driverValues = [decodedToken.id];
        const driverResult = await pool.query(driverQuery, driverValues);
        const driverLicense = driverResult.rows.driver_license;

        const vehicleQuery = 'SELECT reg_number FROM driver_vehicle dv INNER JOIN vehicle v ON dv.vehicle_id = v.id WHERE dv.driver_id = $1';
        const vehicleValues = [decodedToken.id];
        const vehicleResult = await pool.query(vehicleQuery, vehicleValues);
        const vehicleRegNumber = vehicleResult.rows.reg_number;

        const participantQuery = 'INSERT INTO accident_participant (accident_id, participant_driver_license, participant_vehicle_reg_number) VALUES ($1, $2, $3)';
        const participantValues = [accidentId, driverLicense, vehicleRegNumber];

        await pool.query('BEGIN');
        try {
            await pool.query(participantQuery, participantValues);
            await pool.query('COMMIT');
        } catch (participantError) {
            await pool.query('ROLLBACK');
            console.error(`Error adding participant: ${driverLicense}`, participantError);
            throw participantError;
        }

        res.status(201).json({message: 'Accident information added successfully', accidentId});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error adding accident information'});
    }
});

// Получения всех ДТП с участием пользователя
router.get('/user-accidents', async (req, res) => {
    const token = req.headers.authorization;

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_SECRET);

        const query = `
            SELECT a.*
            FROM accident a
                     INNER JOIN accident_participant ap ON a.id = ap.accident_id
                     INNER JOIN driver d ON ap.participant_driver_license = d.driver_license
            WHERE d.id = $1
        `;
        const values = [decodedToken.id];

        const result = await pool.query(query, values);

        res.status(200).json({message: 'User accidents retrieved successfully', data: result.rows});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving user accidents'});
    }
});

module.exports = router;
