const db = require('../config/db');

class HealthService {
  async getProfile(pilgrimID) {
    const [rows] = await db.query(
      'SELECT * FROM Health_Profile WHERE pilgrimID = ?',
      [pilgrimID]
    );

    return rows[0];
  }

  async createOrUpdateProfile(data) {
    const { pilgrimID, dietaryPreferences, healthConditions, allergies, age } = data;

    const [existing] = await db.query(
      'SELECT * FROM Health_Profile WHERE pilgrimID = ?',
      [pilgrimID]
    );

    if (existing.length > 0) {
      await db.query(
        `UPDATE Health_Profile 
         SET dietaryPreferences=?, healthConditions=?, allergies=?, age=? 
         WHERE pilgrimID=?`,
        [dietaryPreferences, healthConditions, allergies, age, pilgrimID]
      );

      return { message: 'Profile updated' };
    } else {
      await db.query(
        `INSERT INTO Health_Profile 
         (pilgrimID, dietaryPreferences, healthConditions, allergies, age)
         VALUES (?, ?, ?, ?, ?)`,
        [pilgrimID, dietaryPreferences, healthConditions, allergies, age]
      );

      return { message: 'Profile created' };
    }
  }
}

module.exports = new HealthService();