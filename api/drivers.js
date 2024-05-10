const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const pool = require('../config/dbConfig');
const router = express.Router();

// Регистрация водителя
router.post('/register', async (req, res) => {
    const {login, password, phone, full_name, driving_experience, driver_license} = req.body;

    try {
        const phoneCheckQuery = 'SELECT * FROM drivers WHERE phone = $1';
        const phoneCheckResult = await pool.query(phoneCheckQuery, [phone]);

        if (phoneCheckResult.rows.length > 0) {
            return res.status(400).json({message: 'Phone number already exists'});
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const query = 'INSERT INTO drivers (login, password, phone, full_name, driving_experience, driver_license) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *';
        const values = [login, hashedPassword, phone, full_name, driving_experience, driver_license];

        const result = await pool.query(query, values);

        res.status(201).json({message: 'Driver registered successfully', data: result.rows[0]});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error registering driver'});
    }
});

// Логин водителя
router.post('/login', async (req, res) => {
    const {login, password} = req.body;

    try {
        const query = 'SELECT * FROM drivers WHERE login = $1';
        const result = await pool.query(query, [login]);

        if (result.rows.length === 0) {
            return res.status(401).json({message: 'Invalid login credentials'});
        }

        const driver = result.rows[0];
        const passwordMatch = await bcrypt.compare(password, driver.password);

        if (!passwordMatch) {
            return res.status(401).json({message: 'Invalid login credentials'});
        }

        const token = jwt.sign({id: driver.id, login: driver.login}, 'your_secret_key', {expiresIn: '1h'});

        res.status(200).json({message: 'Login successful', token});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error logging in'});
    }
});

module.exports = router;
