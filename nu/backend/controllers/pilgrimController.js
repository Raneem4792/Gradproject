const db = require('../config/db');

const getPilgrimHomeData = async (req, res) => {
  try {
    const { pilgrimID } = req.params;

    const [pilgrimRows] = await db.query(
      `SELECT pilgrimID, fullName, email, phoneNumber, campaignID
       FROM pilgrim
       WHERE pilgrimID = ?`,
      [pilgrimID]
    );

    if (pilgrimRows.length === 0) {
      return res.status(404).json({
        message: 'Pilgrim not found',
      });
    }

    const pilgrim = pilgrimRows[0];

    const [orderRows] = await db.query(
      `SELECT 
          mo.orderID,
          mo.requestDate,
          mo.status,
          m.mealName,
          m.protein,
          m.carbohydrates,
          m.calories
       FROM meal_order mo
       JOIN Meal m ON mo.mealID = m.mealID
       WHERE mo.pilgrimID = ?
       ORDER BY mo.requestDate DESC
       LIMIT 1`,
      [pilgrimID]
    );

    let latestOrder = null;

    if (orderRows.length > 0) {
      const order = orderRows[0];
      latestOrder = {
        orderID: order.orderID,
        mealName: order.mealName,
        requestDate: order.requestDate,
        status: order.status,
        kcalLine: `${order.protein}g Protein · ${order.carbohydrates}g Carbs · ${order.calories} kcal`,
      };
    }

    return res.status(200).json({
      fullName: pilgrim.fullName,
      latestOrder,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Error fetching pilgrim home data',
      error: error.message,
    });
  }
};


// ✅ الجديد: جلب البروفايل كامل
const getPilgrimProfile = async (req, res) => {
  try {
    const { pilgrimID } = req.params;

    const [rows] = await db.query(
      `
      SELECT 
        p.pilgrimID,
        p.fullName,
        p.email,
        p.phoneNumber,
        p.campaignID,
        c.campaignName
      FROM Pilgrim p
      LEFT JOIN Campaign c ON p.campaignID = c.campaignID
      WHERE p.pilgrimID = ?
      `,
      [pilgrimID]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: 'Pilgrim not found',
      });
    }

    return res.status(200).json(rows[0]);
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: 'Failed to load profile',
    });
  }
};


// ✅ الجديد: تحديث البروفايل
const updatePilgrimProfile = async (req, res) => {
  try {
    const { pilgrimID, fullName, email, phoneNumber } = req.body;

    if (!pilgrimID || !fullName || !email || !phoneNumber) {
      return res.status(400).json({
        message: 'All fields are required',
      });
    }

    await db.query(
      `
      UPDATE Pilgrim
      SET fullName = ?, email = ?, phoneNumber = ?
      WHERE pilgrimID = ?
      `,
      [fullName, email, phoneNumber, pilgrimID]
    );

    return res.status(200).json({
      message: 'Profile updated successfully',
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: 'Failed to update profile',
    });
  }
};

module.exports = {
  getPilgrimHomeData,
  getPilgrimProfile,    
  updatePilgrimProfile,
};