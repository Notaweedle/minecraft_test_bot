const express = require('express');
const app = express();

app.use(express.json());

app.get('/status', (req, res) => {
  res.json({
    status: 'Running',
    timestamp: new Date().toISOString()
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

const sequelize = require('./common/database');
const defineUser = require('./common/models/User');
const User = defineUser(sequelize);

sequelize.sync();

const authRoutes = require('./authorization/routes');
app.use('/', authRoutes);

const userRoutes = require('./users/routes');
app.use('/user', userRoutes);

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: 'Something went wrong'
  });
});