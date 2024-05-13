const express = require('express');
require('bcrypt');
require('./config/dbConfig');
const cors = require('cors');
const policeOfficersRouter = require('./api/policeDepartment');
const driversRouter = require('./api/drivers');
const swaggerRouter = require('./api/swaggerUi')

const corsOptions = {
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    allowedHeaders: 'Content-Type,Authorization',
    credentials: true,
    optionsSuccessStatus: 200
};

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use(cors(corsOptions));
app.use('/police-department', policeOfficersRouter);
app.use('/drivers', driversRouter);
app.use('/swagger', swaggerRouter)

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});