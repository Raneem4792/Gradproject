const db = require('../config/db');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer');

const resetCodes = {};

const sendResetCode = async (req, res) => {
  const { email } = req.body;

  try {
    const [pilgrim] = await db.query(
      'SELECT email FROM pilgrim WHERE email = ?',
      [email]
    );

    const [provider] = await db.query(
      'SELECT email FROM provider WHERE email = ?',
      [email]
    );

    if (pilgrim.length === 0 && provider.length === 0) {
      return res.status(404).json({ message: 'Email not found' });
    }

    const code = Math.floor(100000 + Math.random() * 900000).toString();

    resetCodes[email] = {
      code,
      expiresAt: Date.now() + 10 * 60 * 1000
    };

    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    });

    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: email,
      subject: 'NUSUQ Password Reset Code',
      html: `
        <div style="font-family: Arial, sans-serif; padding: 20px;">
          <h2 style="color: #0D4C4A;">NUSUQ Password Reset</h2>
          <p>Your password reset code is:</p>
          <h1 style="letter-spacing: 4px; color: #16A085;">${code}</h1>
          <p>This code will expire in 10 minutes.</p>
          <p>If you did not request this, please ignore this email.</p>
        </div>
      `
    });

    res.status(200).json({ message: 'Reset code sent successfully' });
  } catch (error) {
    console.error('Send reset code error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const resetPassword = async (req, res) => {
  const { email, code, newPassword } = req.body;

  try {
    const savedCode = resetCodes[email];

    if (!savedCode) {
      return res.status(400).json({ message: 'No reset code found' });
    }

    if (savedCode.code !== code) {
      return res.status(400).json({ message: 'Invalid code' });
    }

    if (savedCode.expiresAt < Date.now()) {
      delete resetCodes[email];
      return res.status(400).json({ message: 'Code expired' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);

    const [pilgrim] = await db.query(
      'SELECT email FROM pilgrim WHERE email = ?',
      [email]
    );

    const [provider] = await db.query(
      'SELECT email FROM provider WHERE email = ?',
      [email]
    );

    if (pilgrim.length > 0) {
      await db.query(
        'UPDATE pilgrim SET password = ? WHERE email = ?',
        [hashedPassword, email]
      );
    } else if (provider.length > 0) {
      await db.query(
        'UPDATE provider SET password = ? WHERE email = ?',
        [hashedPassword, email]
      );
    } else {
      return res.status(404).json({ message: 'User not found' });
    }

    delete resetCodes[email];

    res.status(200).json({ message: 'Password reset successfully' });
  } catch (error) {
    console.error('Reset password error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = {
  sendResetCode,
  resetPassword
};