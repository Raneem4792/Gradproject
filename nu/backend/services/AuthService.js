const db = require('../config/db');

class AuthService {
  async login(id, password) {
    const [pilgrimRows] = await db.query(
      `SELECT pilgrimID, fullName, email, phoneNumber, campaignID
       FROM Pilgrim
       WHERE pilgrimID = ? AND password = ?`,
      [id, password]
    );

    if (pilgrimRows.length > 0) {
      return {
        message: 'Login successful',
        role: 'pilgrim',
        user: pilgrimRows[0],
      };
    }

    const [providerRows] = await db.query(
      `SELECT providerID, fullName, email, phoneNumber
       FROM Provider
       WHERE providerID = ? AND password = ?`,
      [id, password]
    );

    if (providerRows.length > 0) {
      return {
        message: 'Login successful',
        role: 'provider',
        user: providerRows[0],
      };
    }

    return null;
  }

  async signupPilgrim({
    pilgrimID,
    fullName,
    email,
    phoneNumber,
    password,
    campaignID,
  }) {
    const [existingRows] = await db.query(
      `SELECT pilgrimID
       FROM Pilgrim
       WHERE pilgrimID = ? OR email = ? OR phoneNumber = ?`,
      [pilgrimID, email, phoneNumber]
    );

    if (existingRows.length > 0) {
      throw new Error('Account already exists');
    }

    await db.query(
      `INSERT INTO Pilgrim
       (pilgrimID, fullName, email, phoneNumber, password, campaignID)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [pilgrimID, fullName, email, phoneNumber, password, campaignID]
    );

    return {
      message: 'Pilgrim account created successfully',
    };
  }

  async signupProvider({
    providerID,
    fullName,
    email,
    phoneNumber,
    password,
  }) {
    const [existingRows] = await db.query(
      `SELECT providerID
       FROM Provider
       WHERE providerID = ? OR email = ? OR phoneNumber = ?`,
      [providerID, email, phoneNumber]
    );

    if (existingRows.length > 0) {
      throw new Error('Account already exists');
    }

    await db.query(
      `INSERT INTO Provider
       (providerID, fullName, email, phoneNumber, password)
       VALUES (?, ?, ?, ?, ?)`,
      [providerID, fullName, email, phoneNumber, password]
    );

    return {
      message: 'Provider account created successfully',
    };
  }
}

module.exports = new AuthService();