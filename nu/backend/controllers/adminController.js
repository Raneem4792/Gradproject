const adminService = require('../services/adminService');

const cleanText = (value) => {
  if (value === undefined || value === null) return '';
  return String(value).trim();
};

const validateAccountInfo = ({ fullName, email, phoneNumber }) => {
  const errors = [];

  const finalName = cleanText(fullName);
  const finalEmail = cleanText(email).toLowerCase();
  const finalPhone = cleanText(phoneNumber);

  const nameRegex = /^[\u0600-\u06FFa-zA-Z\s'-]{3,80}$/;
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
  const phoneRegex = /^(05\d{8}|\+9665\d{8})$/;

  if (!finalName || !finalEmail || !finalPhone) {
    errors.push('Full name, email, and phone number are required');
  }

  if (finalName && !nameRegex.test(finalName)) {
    errors.push('Full name must be 3-80 letters only');
  }

  if (finalEmail && !emailRegex.test(finalEmail)) {
    errors.push('Invalid email format');
  }

  if (finalPhone && !phoneRegex.test(finalPhone)) {
    errors.push('Invalid Saudi phone number format');
  }

  return errors;
};

const isValidNotificationText = (value) => {
  /*
    يسمح بـ:
    - عربي
    - إنجليزي
    - أرقام
    - مسافات
    - علامات طبيعية للرسائل
    ويمنع رموز مزعجة أو خطرة مثل:
    < > { } [ ] ` | ^ *
  */
  const regex = /^[\u0600-\u06FFa-zA-Z0-9\s.,'’"()\-_/!?،؛:]+$/;
  return regex.test(value);
};

const validateNotificationData = ({
  title,
  title_ar,
  title_en,
  notificationType,
  messageContent,
  messageContent_ar,
  messageContent_en,
  recipientType,
  recipientUserID,
}) => {
  const errors = [];

  const finalTitleAr = cleanText(title_ar || title);
  const finalTitleEn = cleanText(title_en || title);

  const finalMessageAr = cleanText(messageContent_ar || messageContent);
  const finalMessageEn = cleanText(messageContent_en || messageContent);

  const finalNotificationType = cleanText(notificationType);
  const finalRecipientType = cleanText(recipientType);
  const finalRecipientUserID = cleanText(recipientUserID);

  if (!finalTitleAr && !finalTitleEn) {
    errors.push('Notification title is required');
  }

  if (finalTitleAr && finalTitleAr.length > 255) {
    errors.push('Arabic title must be less than 255 characters');
  }

  if (finalTitleEn && finalTitleEn.length > 255) {
    errors.push('English title must be less than 255 characters');
  }

  if (finalTitleAr && !isValidNotificationText(finalTitleAr)) {
    errors.push('Arabic title contains invalid characters');
  }

  if (finalTitleEn && !isValidNotificationText(finalTitleEn)) {
    errors.push('English title contains invalid characters');
  }

  if (!finalMessageAr && !finalMessageEn) {
    errors.push('Notification message is required');
  }

  if (finalMessageAr && finalMessageAr.length > 1000) {
    errors.push('Arabic message must be less than 1000 characters');
  }

  if (finalMessageEn && finalMessageEn.length > 1000) {
    errors.push('English message must be less than 1000 characters');
  }

  if (finalMessageAr && !isValidNotificationText(finalMessageAr)) {
    errors.push('Arabic message contains invalid characters');
  }

  if (finalMessageEn && !isValidNotificationText(finalMessageEn)) {
    errors.push('English message contains invalid characters');
  }

  if (!finalNotificationType) {
    errors.push('Notification type is required');
  }

  if (!finalRecipientType) {
    errors.push('Recipient type is required');
  }

  const bulkRecipientTypes = ['all_pilgrims', 'all_providers'];

  if (!bulkRecipientTypes.includes(finalRecipientType) && !finalRecipientUserID) {
    errors.push('Recipient user ID is required for a specific user');
  }

  return errors;
};

exports.getAccountsTree = async (req, res) => {
  try {
    const data = await adminService.getAccountsTree();

    res.json(data);
  } catch (error) {
    console.error('Get accounts tree error:', error);

    res.status(500).json({
      message: 'Failed to fetch accounts tree',
      error: error.message,
    });
  }
};

exports.getOrdersMonitor = async (req, res) => {
  try {
    const data = await adminService.getOrdersMonitor();

    res.json(data);
  } catch (error) {
    console.error('Get orders monitor error:', error);

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
      title_ar,
      title_en,
      notificationType,
      messageContent,
      messageContent_ar,
      messageContent_en,
      recipientType,
      recipientUserID,
      createdByAdminID,
    } = req.body;

    const notificationData = {
      title: cleanText(title),
      title_ar: cleanText(title_ar),
      title_en: cleanText(title_en),

      notificationType: cleanText(notificationType),

      messageContent: cleanText(messageContent),
      messageContent_ar: cleanText(messageContent_ar),
      messageContent_en: cleanText(messageContent_en),

      recipientType: cleanText(recipientType),
      recipientUserID: cleanText(recipientUserID),
      createdByAdminID: cleanText(createdByAdminID),
    };

    const validationErrors = validateNotificationData(notificationData);

    if (validationErrors.length > 0) {
      return res.status(400).json({
        message: 'Invalid notification data',
        errors: validationErrors,
      });
    }

    const data = await adminService.createNotification(notificationData);

    res.status(201).json(data);
  } catch (error) {
    console.error('Create notification error:', error);

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
    console.error('Get sent notifications error:', error);

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
      return res.status(404).json({
        message: 'Admin not found',
      });
    }

    res.json(admin);
  } catch (error) {
    console.error('Get admin profile error:', error);

    res.status(500).json({
      message: 'Failed to load admin profile',
      error: error.message,
    });
  }
};

exports.updateAccountStatus = async (req, res) => {
  try {
    const { accountType, accountID } = req.params;
    const { status } = req.body;

    const validTypes = ['provider', 'pilgrim'];
    const validStatuses = ['active', 'inactive'];

    if (!validTypes.includes(accountType)) {
      return res.status(400).json({
        message: 'Invalid account type',
      });
    }

    if (!accountID) {
      return res.status(400).json({
        message: 'Account ID is required',
      });
    }

    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        message: 'Invalid status',
      });
    }

    const updated = await adminService.updateAccountStatus({
      accountType,
      accountID,
      status,
    });

    if (!updated) {
      return res.status(404).json({
        message: 'Account not found',
      });
    }

    res.json({
      message: 'Account status updated successfully',
    });
  } catch (error) {
    console.error('Update account status error:', error);

    res.status(500).json({
      message: 'Failed to update account status',
      error: error.message,
    });
  }
};

exports.updateAccountInfo = async (req, res) => {
  try {
    const { accountType, accountID } = req.params;
    const { fullName, email, phoneNumber } = req.body;

    const validTypes = ['provider', 'pilgrim'];

    if (!validTypes.includes(accountType)) {
      return res.status(400).json({
        message: 'Invalid account type',
      });
    }

    const validationErrors = validateAccountInfo({
      fullName,
      email,
      phoneNumber,
    });

    if (validationErrors.length > 0) {
      return res.status(400).json({
        message: 'Invalid account information',
        errors: validationErrors,
      });
    }

    const updated = await adminService.updateAccountInfo({
      accountType,
      accountID,
      fullName: cleanText(fullName),
      email: cleanText(email).toLowerCase(),
      phoneNumber: cleanText(phoneNumber),
    });

    if (!updated) {
      return res.status(404).json({
        message: 'Account not found',
      });
    }

    res.json({
      message: 'Account information updated successfully',
    });
  } catch (error) {
    console.error('Update account info error:', error);

    res.status(500).json({
      message: 'Failed to update account information',
      error: error.message,
    });
  }
};

exports.getAdminReceivedNotifications = async (req, res) => {
  try {
    const { adminID } = req.params;

    const data = await adminService.getAdminReceivedNotifications(
      adminID
    );

    res.json(data);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: 'Failed to fetch admin notifications',
    });
  }
};

exports.getAdminUnreadCount = async (req, res) => {
  try {
    const { adminID } = req.params;

    const data = await adminService.getAdminUnreadCount(adminID);

    res.json(data);
  } catch (error) {
    res.status(500).json({
      message: 'Failed to fetch unread count',
      error: error.message,
    });
  }
};

exports.markAdminNotificationAsRead = async (req, res) => {
  try {
    const { notificationID } = req.params;

    await adminService.markAdminNotificationAsRead(notificationID);

    res.json({
      message: 'Notification marked as read',
    });
  } catch (error) {
    res.status(500).json({
      message: 'Failed to mark notification as read',
      error: error.message,
    });
  }
};

exports.markAllAdminNotificationsAsRead = async (req, res) => {
  try {
    const { adminID } = req.params;

    await adminService.markAllAdminNotificationsAsRead(adminID);

    res.json({
      message: 'All notifications marked as read',
    });
  } catch (error) {
    res.status(500).json({
      message: 'Failed to mark all notifications as read',
      error: error.message,
    });
  }
};