const express = require('express');
const bcrypt = require('bcrypt');
const pool = require('../config/dbConfig');
const router = express.Router();

// Регистрация сотрудника
router.post('/register', async (req, res) => {
    const {login, password, phone, full_name, department_id} = req.body;

    try {
        const phoneCheckQuery = 'SELECT * FROM police_officers WHERE phone = $1';
        const phoneCheckResult = await pool.query(phoneCheckQuery, [phone]);

        if (phoneCheckResult.rows.length > 0) {
            return res.status(400).json({message: 'Phone number already exists'});
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const query = 'INSERT INTO police_officers (login, password, phone, full_name, department_id) VALUES ($1, $2, $3, $4, $5) RETURNING *';
        const values = [login, hashedPassword, phone, full_name, department_id];

        const result = await pool.query(query, values);

        res.status(201).json({message: 'Police officer registered successfully', data: result.rows[0]});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error registering police officer'});
    }
});

// Логин сотрудника
router.post('/login', async (req, res) => {
    const {login, password} = req.body;

    try {
        const query = 'SELECT * FROM police_officers WHERE login = $1';
        const result = await pool.query(query, [login]);

        if (result.rows.length === 0) {
            return res.status(401).json({message: 'Invalid login credentials'});
        }

        const user = result.rows[0];
        const passwordMatch = await bcrypt.compare(password, user.password);

        if (!passwordMatch) {
            return res.status(401).json({message: 'Invalid login credentials'});
        }

        res.status(200).json({message: 'Login successful', data: user});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error logging in'});
    }
});

module.exports = router;
