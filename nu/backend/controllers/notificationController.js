const db = require('../config/db');

exports.getNotifications = async (req, res) => {
    // userId هنا سيستقبل القيمة من الفرونت أند (مثل '1127611513')
    const { userId, userType } = req.params; 
    try {
        const [rows] = await db.query(
            // تعديل المسميات لتطابق ملف الـ SQL الخاص بك
            'SELECT * FROM notification WHERE recipientUserID = ? AND recipientType = ? ORDER BY timestamp DESC',
            [userId, userType]
        );
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
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
    res.status(500).json({
      error: error.message,
    });
  }
};