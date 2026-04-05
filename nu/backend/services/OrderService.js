const db = require('../config/db');
const MealOrder = require('../models/MealOrder');

class OrderService {
    // ✅ إنشاء طلب
    async createOrder(mealID, pilgrimID) {
        const [result] = await db.query(
            `INSERT INTO Meal_Order (mealID, pilgrimID, status)
       VALUES (?, ?, 'pending')`,
            [mealID, pilgrimID]
        );

        return {
            message: 'Order created successfully',
            orderID: result.insertId,
        };
    }

    // ✅ جلب الطلبات حسب الحاج
    async getOrdersByPilgrim(pilgrimID) {
        const [rows] = await db.query(`
  SELECT 
    mo.orderID,
    mo.requestDate,
    mo.status,
    mo.pilgrimID,
    mo.mealID,
    m.mealName,
    r.stars
  FROM Meal_Order mo
  JOIN Meal m ON mo.mealID = m.mealID
  LEFT JOIN Rate r ON mo.orderID = r.orderID
  WHERE mo.pilgrimID = ?
  ORDER BY mo.requestDate DESC
`, [pilgrimID]);

        return rows.map(row => MealOrder.fromRow(row));
    }
}

module.exports = new OrderService();