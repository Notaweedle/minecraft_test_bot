const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const sequelize = require('../common/database');
const defineUser = require('../common/models/User');
const User = defineUser(sequelize);

const Ajv = require('ajv');
const ajv = new Ajv();
const schema = {
  type: 'object',
  required: ['username', 'password', 'mcUsername'],
  properties: {
    username: { type: 'string', minLength: 3 },
    password: { type: 'string', minLength: 6 },
    mcUsername: { type: 'string', minLength: 3 }
  }
};
const validate = ajv.compile(schema);

const encryptPassword = (password) =>
  crypto.createHash('sha256').update(password).digest('hex');

const generateAccessToken = (username, userId) =>
  jwt.sign({ username, userId }, 'your-secret-key', { expiresIn: '24h' });

exports.register = async (req, res) => {
    if (!validate(req.body)) {
    return res.status(400).json({ error: 'Invalid input', details: validate.errors });
  }
  try {
    const { username, password, mcUsername } = req.body;
    const encryptedPassword = encryptPassword(password);
    const user = await User.create({
      username,
      password: encryptedPassword,
      mcUsername,
    });
    const accessToken = generateAccessToken(username, user.id);
    res.status(201).json({
      success: true,
      user: { id: user.id, username: user.username },
      token: accessToken
    });
  } catch (err) {
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