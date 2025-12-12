const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const sequelize = require('../common/database');
const defineUser = require('../common/models/User');
const User = defineUser(sequelize);

const Ajv = require('ajv');
const ajv = new Ajv();
const schema = {
  type: 'object',
  required: ['username', 'password', 'serverIp','serverPort','serverPassword'],
  properties: {
    username: { type: 'string', minLength: 3 },
    password: { type: 'string', minLength: 6 },
    serverIp: { type: 'string', minLength: 3 },
    serverPort: { type: 'number', minimum: 1, maximum: 65535 },
    serverPassword: { type: 'string', minLength: 3 },
  }
};
const validate = ajv.compile(schema);

const encryptPassword = (password) =>
  crypto.createHash('sha256').update(password).digest('hex');

const encryptServerIP = (serverIp) =>
  crypto.createHash('sha256').update(serverIp).digest('hex');

const generateAccessToken = (username, userId) =>
  jwt.sign({ username, userId }, 'your-secret-key', { expiresIn: '24h' });

exports.register = async (req, res) => {
  if (!validate(req.body)) {
    return res.status(400).json({ error: 'Invalid input', details: validate.errors });
  }
  try {
    const { username, password, serverIp, serverPort, serverPassword } = req.body;
    
    console.log('Attempting to register:', { username }); // Debug log
    
    // Check both username and mcUsername
    const existingUsername = await User.findOne({ where: { username } });
    
    if (existingUsername) {
      console.log('Username conflict:', username);
      return res.status(409).json({ 
        success: false, 
        error: 'Username already exists' 
      });
    }
    
    const encryptedPassword = encryptPassword(password);
    const user = await User.create({
      username,
      password: encryptedPassword,
      serverIp: encryptServerIP,
      serverPort,
      serverPassword
    });
    
    console.log('User created successfully:', user.id);
    
    const accessToken = generateAccessToken(username, user.id);
    res.status(201).json({
      success: true,
      user: { id: user.id, username: user.username },
      token: accessToken
    });
  } catch (err) {
    console.error('Full registration error:', err); // Full error details
    
    if (err.name === 'SequelizeUniqueConstraintError') {
      console.log('Unique constraint violated on:', err.fields); // Shows which field
      return res.status(409).json({ 
        success: false, 
        error: `Already exists: ${Object.keys(err.fields).join(', ')}` 
      });
    }
    
    if (err.name === 'SequelizeValidationError') {
      return res.status(400).json({ 
        success: false, 
        error: 'Invalid data provided',
        details: err.errors.map(e => e.message)
      });
    }
    
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.login = async (req, res) => {
  const { username, password } = req.body;
  const encrypted = encryptPassword(password);
  const user = await User.findOne({ where: { username } });

  if (!user || user.password !== encrypted)
    return res.status(401).json({ error: 'Invalid credentials' });

  const token = generateAccessToken(username, user.id);
  res.json({ success: true, user, token });
};