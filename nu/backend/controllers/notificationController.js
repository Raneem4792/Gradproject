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