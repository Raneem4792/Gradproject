const adminService = require('../services/adminService');

exports.getAccountsTree = async (req, res) => {
  try {

    const data =
      await adminService.getAccountsTree();

    res.json(data);

  } catch (error) {

    res.status(500).json({
      message: 'Failed to fetch accounts tree',
      error: error.message
    });
  }
};

exports.getOrdersMonitor = async (req, res) => {
  try {
    const data = await adminService.getOrdersMonitor();
    res.json(data);
  } catch (error) {
    res.status(500).json({
      message: 'Failed to fetch orders monitor',
      error: error.message,
    });
  }
};

exports.createNotification = async (req, res) => {
  try {

    const {
      title,
      notificationType,
      messageContent,
      recipientType,
      recipientUserID,
      createdByAdminID,
    } = req.body;

    if (
      !title ||
      !notificationType ||
      !messageContent ||
      !recipientType
    ) {
      return res.status(400).json({
        message: 'Missing required fields',
      });
    }

    const data =
      await adminService.createNotification({
        title,
        notificationType,
        messageContent,
        recipientType,
        recipientUserID,
        createdByAdminID,
      });

    res.status(201).json(data);

  } catch (error) {

    res.status(500).json({
      message: 'Failed to create notification',
      error: error.message,
    });
  }
};

exports.getSentNotifications = async (req, res) => {
  try {
    const data = await adminService.getSentNotifications();
    res.json(data);
  } catch (error) {
    res.status(500).json({
      message: 'Failed to fetch sent notifications',
      error: error.message,
    });
  }
};

exports.getAdminProfile = async (req, res) => {
  try {
    const { adminID } = req.params;

    const admin = await adminService.getAdminProfile(adminID);

    if (!admin) {
      return res.status(404).json({ message: 'Admin not found' });
    }

    res.json(admin);
  } catch (error) {
    res.status(500).json({
      message: 'Failed to load admin profile',
      error: error.message,
    });
  }
};