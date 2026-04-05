const db = require('../config/db');

const getPilgrimHomeData = async (req, res) => {
  try {
    const { pilgrimID } = req.params;

    // بيانات الحاج
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

    // آخر طلب للحاج
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
        kcalLine: '${order.protein} Protein · ${order.carbohydrates}g Carbs · ${order.calories} kcal',
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

module.exports = { getPilgrimHomeData };