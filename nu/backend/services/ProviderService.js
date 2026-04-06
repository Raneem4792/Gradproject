const db = require('../config/db');

const getProviderProfile = async (req, res) => {
  try {
    const { providerID } = req.params;

    const [rows] = await db.query(
      `
      SELECT 
        providerID,
        fullName,
        email,
        phoneNumber
      FROM provider
      WHERE providerID = ?
      `,
      [providerID]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: 'Provider not found',
      });
    }

    return res.status(200).json(rows[0]);
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: 'Failed to load provider profile',
    });
  }
};

const updateProviderProfile = async (req, res) => {
  try {
    const { providerID, fullName, email, phoneNumber } = req.body;

    if (!providerID || !fullName || !email || !phoneNumber) {
      return res.status(400).json({
        message: 'All fields are required',
      });
    }

    await db.query(
      `
      UPDATE provider
      SET fullName = ?, email = ?, phoneNumber = ?
      WHERE providerID = ?
      `,
      [fullName, email, phoneNumber, providerID]
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
  getProviderProfile,
  updateProviderProfile,
};