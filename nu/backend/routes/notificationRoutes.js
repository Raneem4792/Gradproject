const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');

router.get('/:userId/:userType', notificationController.getNotifications);

module.exports = router;