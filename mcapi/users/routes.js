const router = require('express').Router();
const UserController = require('./controller');
const AuthController = require('../authorization/controller');
const { check } = require('../common/middlewears/IsAuthenticated');

router.get('/', check, UserController.getUser);
router.get('/all', check, UserController.getAllUsers);
router.post('/login', AuthController.login);

module.exports = router;