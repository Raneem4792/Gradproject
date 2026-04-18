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
    const normalizedEmail = String(email).trim().toLowerCase();
    const normalizedPhone = String(phoneNumber).trim();
    const normalizedFullName = String(fullName).trim();
    const normalizedPilgrimID = String(pilgrimID).trim();

    const [pilgrimIdRows] = await db.query(
      `SELECT pilgrimID
       FROM Pilgrim
       WHERE pilgrimID = ?`,
      [normalizedPilgrimID]
    );

    if (pilgrimIdRows.length > 0) {
      const error = new Error('This pilgrim ID is already registered');
      error.field = 'pilgrimID';
      throw error;
    }

    const [emailRows] = await db.query(
      `SELECT email
       FROM Pilgrim
       WHERE email = ?`,
      [normalizedEmail]
    );

    if (emailRows.length > 0) {
      const error = new Error('This email is already registered');
      error.field = 'email';
      throw error;
    }

    const [phoneRows] = await db.query(
      `SELECT phoneNumber
       FROM Pilgrim
       WHERE phoneNumber = ?`,
      [normalizedPhone]
    );

    if (phoneRows.length > 0) {
      const error = new Error('This phone number is already registered');
      error.field = 'phoneNumber';
      throw error;
    }

    const [campaignRows] = await db.query(
      `SELECT campaignID
       FROM Campaign
       WHERE campaignID = ?`,
      [campaignID]
    );

    if (campaignRows.length === 0) {
      const error = new Error('Campaign ID does not exist');
      error.field = 'campaignID';
      throw error;
    }

    await db.query(
      `INSERT INTO Pilgrim
       (pilgrimID, fullName, email, phoneNumber, password, campaignID)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [
        normalizedPilgrimID,
        normalizedFullName,
        normalizedEmail,
        normalizedPhone,
        password,
        campaignID,
      ]
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
    const normalizedEmail = String(email).trim().toLowerCase();
    const normalizedPhone = String(phoneNumber).trim();
    const normalizedFullName = String(fullName).trim();
    const normalizedProviderID = String(providerID).trim();

    const [providerIdRows] = await db.query(
      `SELECT providerID
       FROM Provider
       WHERE providerID = ?`,
      [normalizedProviderID]
    );

    if (providerIdRows.length > 0) {
      const error = new Error('This provider ID is already registered');
      error.field = 'providerID';
      throw error;
    }

    const [emailRows] = await db.query(
      `SELECT email
       FROM Provider
       WHERE email = ?`,
      [normalizedEmail]
    );

    if (emailRows.length > 0) {
      const error = new Error('This email is already registered');
      error.field = 'email';
      throw error;
    }

    const [phoneRows] = await db.query(
      `SELECT phoneNumber
       FROM Provider
       WHERE phoneNumber = ?`,
      [normalizedPhone]
    );

    if (phoneRows.length > 0) {
      const error = new Error('This phone number is already registered');
      error.field = 'phoneNumber';
      throw error;
    }

    await db.query(
      `INSERT INTO Provider
       (providerID, fullName, email, phoneNumber, password)
       VALUES (?, ?, ?, ?, ?)`,
      [
        normalizedProviderID,
        normalizedFullName,
        normalizedEmail,
        normalizedPhone,
        password,
      ]
    );

    return {
      message: 'Provider account created successfully',
    };
  }
}

module.exports = new AuthService();