const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');

router.get(
  '/unread-count/:userId/:userType',
  notificationController.getUnreadCount
);

router.put(
  '/mark-read/:userId/:userType',
  notificationController.markAsRead
);

router.get(
  '/:userId/:userType',
  notificationController.getNotifications
);

module.exports = router;