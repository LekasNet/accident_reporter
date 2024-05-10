const express = require('express');
require('bcrypt');
require('./config/dbConfig');
const policeOfficersRouter = require('./api/policeOfficers');
const driversRouter = require('./api/drivers');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use('/police-officers', policeOfficersRouter);
app.use('/drivers', driversRouter);

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});