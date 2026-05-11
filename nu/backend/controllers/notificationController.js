const db = require('../config/db');

const normalizeNotification = (row) => {
  const titleAr = row.title_ar || row.title || '';
  const titleEn = row.title_en || row.title || '';

  const messageAr = row.messageContent_ar || row.messageContent || '';
  const messageEn = row.messageContent_en || row.messageContent || '';

  return {
    ...row,

    // القديم نخليه موجود عشان الفرونت القديم ما ينكسر
    title: row.title || titleAr || titleEn,
    messageContent: row.messageContent || messageAr || messageEn,

    // الجديد
    title_ar: titleAr,
    title_en: titleEn,
    messageContent_ar: messageAr,
    messageContent_en: messageEn,
  };
};

exports.getNotifications = async (req, res) => {
  const { userId, userType } = req.params;

  try {
    const [rows] = await db.query(
      `
      SELECT *
      FROM notification
      WHERE recipientUserID = ?
      AND recipientType = ?
      ORDER BY timestamp DESC
      `,
      [userId, userType]
    );

    res.json(rows.map(normalizeNotification));
  } catch (error) {
    console.error('Get notifications error:', error);

    res.status(500).json({
      error: error.message,
    });
  }
};

exports.getUnreadCount = async (req, res) => {
  const { userId, userType } = req.params;

  try {
    const [rows] = await db.query(
      `
      SELECT COUNT(*) AS count
      FROM notification
      WHERE recipientUserID = ?
      AND recipientType = ?
      AND isRead = 0
      `,
      [userId, userType]
    );

    res.json(rows[0]);
  } catch (error) {
    console.error('Get unread count error:', error);

    res.status(500).json({
      error: error.message,
    });
  }
};

exports.markAsRead = async (req, res) => {
  const { userId, userType } = req.params;

  try {
    await db.query(
      `
      UPDATE notification
      SET isRead = 1
      WHERE recipientUserID = ?
      AND recipientType = ?
      `,
      [userId, userType]
    );

    res.json({
      message: 'Notifications marked as read',
    });
  } catch (error) {
    console.error('Mark notifications as read error:', error);

    res.status(500).json({
      error: error.message,
    });
  }
};