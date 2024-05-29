const express = require('express');
const bcrypt = require('bcrypt');
const pool = require('../config/dbConfig');
const jwt = require("jsonwebtoken");
const router = express.Router();

// Регистрация сотрудника
router.post('/register', async (req, res) => {
    const {login, password, phone, full_name, department_id} = req.body;

    try {
        const phoneCheckQuery = 'SELECT * FROM police_officer WHERE phone = $1';
        const phoneCheckResult = await pool.query(phoneCheckQuery, [phone]);

        if (phoneCheckResult.rows.length > 0) {
            return res.status(400).json({message: 'Phone number already exists'});
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const query = 'INSERT INTO police_officer (login, password, phone, full_name, department_id) VALUES ($1, $2, $3, $4, $5) RETURNING *';
        const values = [login, hashedPassword, phone, full_name, department_id];

        const result = await pool.query(query, values);

        res.status(201).json({message: 'Police officer registered successfully', data: result.rows[0]});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error registering police officer'});
    }
});

// Логин сотрудника ГИБДД
router.post('/login', async (req, res) => {
    const {login, password} = req.body;

    try {
        const query = 'SELECT * FROM police_officer WHERE login = $1';
        const result = await pool.query(query, [login]);

        if (result.rows.length === 0) {
            return res.status(401).json({message: 'Invalid login credentials'});
        }

        const officer = result.rows[0];
        const passwordMatch = await bcrypt.compare(password, officer.password);

        if (!passwordMatch) {
            return res.status(401).json({message: 'Invalid login credentials'});
        }

        const token = jwt.sign({
            id: officer.id,
            login: officer.login
        }, process.env.JWT_ACCESS_SECRET, {expiresIn: '1d'});

        res.status(200).json({message: 'Login successful', token});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error logging in'});
    }
});

// Получения информации о текущем сотруднике ГИБДД
router.get('/profile', async (req, res) => {
    const token = req.headers.authorization;

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_SECRET);

        const query = 'SELECT * FROM police_officer WHERE id = $1';
        const result = await pool.query(query, [decodedToken.id]);

        if (result.rows.length === 0) {
            return res.status(404).json({message: 'Officer not found'});
        }

        const officer = result.rows[0];

        res.status(200).json({message: 'Officer profile retrieved successfully', data: officer});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving officer profile'});
    }
});

// Получения всех ДТП
router.get('/accidents', async (req, res) => {
    const token = req.headers.authorization;

    try {
        jwt.verify(token, process.env.JWT_ACCESS_SECRET);

        const query = `
            SELECT a.id,
                   a.report_number,
                   a.date,
                   a.location,
                   a.accident_type,
                   a.accident_cause,
                   a.casualties,
                   array_agg(json_build_object('driver_license', ap.participant_driver_license, 'vehicle_reg_number', ap.participant_vehicle_reg_number)) AS participants
            FROM accident a
                     LEFT JOIN accident_participant ap ON a.id = ap.accident_id
            GROUP BY a.id, a.report_number, a.date, a.location, a.accident_type, a.accident_cause, a.casualties
            ORDER BY a.date DESC, a.id;`;

        const result = await pool.query(query);

        const accidentsWithParticipants = result.rows.map(accident => {
            return {
                ...accident,
                participants: accident.participants.filter(participant => participant.driver_license != null)
            };
        });

        res.status(200).json({message: 'All accidents retrieved successfully', data: accidentsWithParticipants});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving all accidents'});
    }
});

// Получение сведений о водителях
router.get('/drivers', async (req, res) => {
    const token = req.headers.authorization;

    try {
        jwt.verify(token, process.env.JWT_ACCESS_SECRET);
        const query = 'SELECT * FROM driver';
        const result = await pool.query(query);

        res.status(200).json({message: 'All drivers retrieved successfully', data: result.rows});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving all drivers'});
    }
});

// Получение сведений об автомобилях
router.get('/vehicles', async (req, res) => {
    const token = req.headers.authorization;

    try {
        jwt.verify(token, process.env.JWT_ACCESS_SECRET);
        const query = 'SELECT * FROM vehicle';
        const result = await pool.query(query);

        res.status(200).json({message: 'All vehicles retrieved successfully', data: result.rows});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving all vehicles'});
    }
});


module.exports = router;