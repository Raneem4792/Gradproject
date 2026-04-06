const db = require('../config/db');
const MealOrder = require('../models/MealOrder');

class OrderService {
  async createOrder(mealID, pilgrimID) {
    const [result] = await db.query(
      `INSERT INTO meal_order (mealID, pilgrimID, status)
       VALUES (?, ?, 'pending')`,
      [mealID, pilgrimID]
    );

    return {
      message: 'Order created successfully',
      orderID: result.insertId,
    };
  }

  async getOrdersByPilgrim(pilgrimID) {
    const [rows] = await db.query(
      `
      SELECT 
        mo.orderID,
        mo.requestDate,
        mo.status,
        mo.pilgrimID,
        p.fullName AS pilgrimName,
        mo.mealID,
        m.mealName,
        m.mealType,
        c.campaignID,
        c.campaignName,
        c.campaignNumber,
        r.stars
      FROM meal_order mo
      JOIN meal m ON mo.mealID = m.mealID
      JOIN pilgrim p ON mo.pilgrimID = p.pilgrimID
      LEFT JOIN campaign c ON p.campaignID = c.campaignID
      LEFT JOIN Rate r ON mo.orderID = r.orderID
      WHERE mo.pilgrimID = ?
      ORDER BY mo.requestDate DESC
      `,
      [pilgrimID]
    );

    return rows.map((row) => MealOrder.fromRow(row));
  }

  async getCampaignsByProvider(providerID) {
    const [rows] = await db.query(
      `
      SELECT
        campaignID,
        campaignName,
        campaignNumber
      FROM campaign
      WHERE providerID = ?
      ORDER BY campaignName ASC
      `,
      [providerID]
    );

    return rows;
  }

  async getOrdersByProvider(providerID, campaignID = null) {
    let sql = `
      SELECT
        mo.orderID,
        mo.requestDate,
        mo.status,
        mo.pilgrimID,
        p.fullName AS pilgrimName,
        mo.mealID,
        m.mealName,
        m.mealType,
        c.campaignID,
        c.campaignName,
        c.campaignNumber,
        r.stars
      FROM meal_order mo
      JOIN meal m ON mo.mealID = m.mealID
      JOIN pilgrim p ON mo.pilgrimID = p.pilgrimID
      LEFT JOIN campaign c ON p.campaignID = c.campaignID
      LEFT JOIN Rate r ON mo.orderID = r.orderID
      WHERE m.providerID = ?
    `;

    const params = [providerID];

    if (campaignID != null) {
      sql += ` AND c.campaignID = ?`;
      params.push(campaignID);
    }

    sql += ` ORDER BY mo.requestDate DESC`;

    const [rows] = await db.query(sql, params);

    return rows.map((row) => MealOrder.fromRow(row));
  }
}

module.exports = new OrderService();