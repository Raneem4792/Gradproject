const db = require('../config/db');

class CampaignService {
  static async getCampaignsByProvider(providerID) {
    const sql = `
      SELECT * FROM campaign
      WHERE providerID = ?
      ORDER BY campaignID DESC
    `;

    const [rows] = await db.query(sql, [providerID]);
    return rows;
  }

  static async createCampaign(data) {
    const sql = `
      INSERT INTO campaign
      (campaignName, campaignNumber, numberOfPilgrims, arrivalDetails, providerID)
      VALUES (?, ?, ?, ?, ?)
    `;

    const [result] = await db.query(sql, [
      data.campaignName,
      data.campaignNumber,
      data.numberOfPilgrims,
      data.arrivalDetails,
      data.providerID,
    ]);

    return result;
  }

  static async updateCampaign(campaignID, data) {
    const sql = `
      UPDATE campaign
      SET campaignName = ?, campaignNumber = ?, numberOfPilgrims = ?, arrivalDetails = ?
      WHERE campaignID = ?
    `;

    const [result] = await db.query(sql, [
      data.campaignName,
      data.campaignNumber,
      data.numberOfPilgrims,
      data.arrivalDetails,
      campaignID,
    ]);

    return result;
  }

  static async deleteCampaign(campaignID) {
    const sql = `DELETE FROM campaign WHERE campaignID = ?`;
    const [result] = await db.query(sql, [campaignID]);
    return result;
  }
}

module.exports = CampaignService;