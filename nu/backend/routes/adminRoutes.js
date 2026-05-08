const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');

router.get(
  '/accounts-tree',
  adminController.getAccountsTree
);

router.get(
  '/orders-monitor',
  adminController.getOrdersMonitor
);

router.post(
  '/notifications',
  adminController.createNotification
);

router.get(
  '/notifications',
  adminController.getSentNotifications
);

router.get('/profile/:adminID', adminController.getAdminProfile);

module.exports = router;