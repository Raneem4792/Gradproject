const db = require('../config/db');
const Rate = require('../models/Rate');

class RateService {
  async createRate(orderID, stars, comment) {
    const [existingRows] = await db.query(
      'SELECT ratingID FROM Rate WHERE orderID = ?',
      [orderID]
    );

    if (existingRows.length > 0) {
      throw new Error('This order has already been reviewed');
    }

    const [orderRows] = await db.query(
      'SELECT orderID, status FROM Meal_Order WHERE orderID = ?',
      [orderID]
    );

    if (orderRows.length === 0) {
      throw new Error('Order not found');
    }

    const [result] = await db.query(
      `INSERT INTO Rate (orderID, stars, comment, reviewDateTime)
       VALUES (?, ?, ?, NOW())`,
      [orderID, stars, comment]
    );

    return {
      message: 'Review submitted successfully',
      ratingID: result.insertId,
    };
  }

  async getRateByOrder(orderID) {
    const [rows] = await db.query(
      `SELECT ratingID, orderID, stars, comment, reviewDateTime, providerReply, replyDateTime
       FROM Rate
       WHERE orderID = ?`,
      [orderID]
    );

    if (rows.length === 0) {
      return null;
    }

    return Rate.fromRow(rows[0]);
  }
}

module.exports = new RateService();