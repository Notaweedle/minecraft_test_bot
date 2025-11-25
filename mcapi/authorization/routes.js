const router = require('express').Router();
const AuthController = require('./controller');
router.post('/signup', AuthController.register);
module.exports = router;

router.post('/login', AuthController.login);