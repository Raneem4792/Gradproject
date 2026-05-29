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

router.patch(
  '/accounts/:accountType/:accountID/status',
  adminController.updateAccountStatus
);

router.patch(
  '/accounts/:accountType/:accountID',
  adminController.updateAccountInfo
);
router.get(
  '/notifications/received/:adminID',
  adminController.getAdminReceivedNotifications
);

router.get('/notifications/unread-count', adminController.getAdminUnreadCount);

router.put(
  '/notifications/:notificationID/read',
  adminController.markAdminNotificationAsRead
);

router.put(
  '/notifications/mark-all-read',
  adminController.markAllAdminNotificationsAsRead
);

router.get(
  '/notifications/unread-count/:adminID',
  adminController.getAdminUnreadCount
);

router.put(
  '/notifications/mark-all-read/:adminID',
  adminController.markAllAdminNotificationsAsRead
);

module.exports = router;