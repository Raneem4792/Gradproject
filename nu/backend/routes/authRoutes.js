const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/login', (req, res) => authController.login(req, res));
router.post('/signup/pilgrim', (req, res) => authController.signupPilgrim(req, res));
router.post('/signup/provider', (req, res) => authController.signupProvider(req, res));

module.exports = router;