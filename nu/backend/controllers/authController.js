const authService = require('../services/AuthService');

function normalizeSpaces(value) {
  return String(value || '').trim().replace(/\s+/g, ' ');
}

function normalizeSpaces(value) {
  return String(value || '').trim().replace(/\s+/g, ' ');
}

function validateFullName(fullName) {
  const value = normalizeSpaces(fullName);

  if (!value) {
    return 'Full name is required';
  }

  if (value.length < 3) {
    return 'Full name must be at least 3 characters';
  }

  if (value.length > 50) {
    return 'Full name must not exceed 50 characters';
  }

  if (/[0-9]/.test(value)) {
    return 'Full name must not contain numbers';
  }

  const isArabicOnly = /^[\u0600-\u06FF ]+$/.test(value);
  const isEnglishOnly = /^[A-Za-z ]+$/.test(value);

  if (!isArabicOnly && !isEnglishOnly) {
    return 'Full name must be Arabic only or English only';
  }

  return null;
}

function validateEmail(email) {
  const value = String(email || '').trim().toLowerCase();

  if (!value) {
    return 'Email is required';
  }

  if (value.includes(' ')) {
    return 'Email must not contain spaces';
  }

  if (value.length > 100) {
    return 'Email is too long';
  }

  if (!/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(value)) {
    return 'Please enter a valid email address';
  }

  return null;
}

function validatePhoneNumber(phoneNumber) {
  const value = String(phoneNumber || '').trim();

  if (!value) {
    return 'Phone number is required';
  }

  if (!/^\+\d{9,15}$/.test(value)) {
    return 'Phone number must be in a valid international format';
  }

  return null;
}

function validatePassword(password) {
  const value = String(password || '');

  if (!value) {
    return 'Password is required';
  }

  if (value.includes(' ')) {
    return 'Password must not contain spaces';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }

  if (value.length > 20) {
    return 'Password must not exceed 20 characters';
  }

  if (!/[A-Z]/.test(value)) {
    return 'Password must contain at least one uppercase letter';
  }

  if (!/[a-z]/.test(value)) {
    return 'Password must contain at least one lowercase letter';
  }

  if (!/[0-9]/.test(value)) {
    return 'Password must contain at least one number';
  }

  if (!/[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]/.test(value)) {
    return 'Password must contain at least one special character';
  }

  if (!/^[A-Za-z0-9!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]+$/.test(value)) {
    return 'Password must use English letters, numbers, and symbols only';
  }

  return null;
}

function validateNumericId(value, label) {
  const text = String(value || '').trim();

  if (!text) {
    return `${label} is required`;
  }

  if (text.includes(' ')) {
    return `${label} must not contain spaces`;
  }

  if (!/^\d+$/.test(text)) {
    return `${label} must contain numbers only`;
  }

  if (text.length < 6) {
    return `${label} is too short`;
  }

  if (text.length > 20) {
    return `${label} is too long`;
  }

  return null;
}

function validateCampaignId(campaignID) {
  const text = String(campaignID ?? '').trim();

  if (!text) {
    return 'Campaign ID is required';
  }

  if (text.includes(' ')) {
    return 'Campaign ID must not contain spaces';
  }

  if (!/^\d+$/.test(text)) {
    return 'Campaign ID must contain numbers only';
  }

  if (text.length > 12) {
    return 'Campaign ID is too long';
  }

  if (Number(text) <= 0) {
    return 'Campaign ID must be greater than 0';
  }

  return null;
}

class AuthController {
  _handleSignupError(error, res, accountType = 'account') {
    console.error(`${accountType} signup error:`, error);

    const message = error?.message || '';
    const code = error?.code || '';
    const sqlMessage = (error?.sqlMessage || '').toLowerCase();

    if (error.field && error.message) {
      return res.status(400).json({
        message: error.message,
        field: error.field,
      });
    }

    if (
      message === 'Account already exists' ||
      code === 'ER_DUP_ENTRY' ||
      sqlMessage.includes('duplicate entry')
    ) {
      if (sqlMessage.includes('email')) {
        return res.status(409).json({
          message: 'This email is already registered',
          field: 'email',
        });
      }

      if (sqlMessage.includes('phonenumber')) {
        return res.status(409).json({
          message: 'This phone number is already registered',
          field: 'phoneNumber',
        });
      }

      if (sqlMessage.includes('pilgrimid')) {
        return res.status(409).json({
          message: 'This pilgrim ID is already registered',
          field: 'pilgrimID',
        });
      }

      if (sqlMessage.includes('providerid')) {
        return res.status(409).json({
          message: 'This provider ID is already registered',
          field: 'providerID',
        });
      }

      return res.status(409).json({
        message: 'Account already exists',
      });
    }

    if (
      code === 'ER_NO_REFERENCED_ROW_2' ||
      sqlMessage.includes('foreign key constraint fails')
    ) {
      if (sqlMessage.includes('campaign')) {
        return res.status(400).json({
          message: 'Campaign ID does not exist',
          field: 'campaignID',
        });
      }

      return res.status(400).json({
        message: 'Referenced data does not exist',
      });
    }

    if (code === 'ER_BAD_NULL_ERROR') {
      const match = (error?.sqlMessage || '').match(/Column '(.+?)' cannot be null/i);
      const field = match?.[1] || null;

      return res.status(400).json({
        message: field ? `${field} is required` : 'A required field is missing',
        field,
      });
    }

    if (code === 'ER_DATA_TOO_LONG') {
      const match = (error?.sqlMessage || '').match(/Data too long for column '(.+?)'/i);
      const field = match?.[1] || null;

      return res.status(400).json({
        message: field ? `${field} is too long` : 'One of the fields is too long',
        field,
      });
    }

    if (
      code === 'ER_TRUNCATED_WRONG_VALUE_FOR_FIELD' ||
      code === 'ER_WARN_DATA_OUT_OF_RANGE'
    ) {
      const match = (error?.sqlMessage || '').match(/column '(.+?)'/i);
      const field = match?.[1] || null;

      return res.status(400).json({
        message: field
          ? `${field} has an invalid format`
          : 'One of the entered values has an invalid format',
        field,
      });
    }

    return res.status(500).json({
      message: 'Server error',
    });
  }

  async login(req, res) {
    try {
      const { id, password } = req.body;

      if (!id || !password) {
        return res.status(400).json({
          message: 'ID and password are required',
        });
      }

      const result = await authService.login(id, password);

      if (!result) {
        return res.status(401).json({
          message: 'Invalid credentials',
        });
      }

      return res.status(200).json(result);
    } catch (error) {
      console.error('Login error:', error);
      return res.status(500).json({
        message: 'Server error',
      });
    }
  }

  async signupPilgrim(req, res) {
    try {
      const {
        pilgrimID,
        fullName,
        email,
        phoneNumber,
        password,
        campaignID,
      } = req.body;

      const pilgrimIdError = validateNumericId(pilgrimID, 'Pilgrim ID');
      if (pilgrimIdError) {
        return res.status(400).json({
          message: pilgrimIdError,
          field: 'pilgrimID',
        });
      }

      const fullNameError = validateFullName(fullName);
      if (fullNameError) {
        return res.status(400).json({
          message: fullNameError,
          field: 'fullName',
        });
      }

      const emailError = validateEmail(email);
      if (emailError) {
        return res.status(400).json({
          message: emailError,
          field: 'email',
        });
      }

      const phoneError = validatePhoneNumber(phoneNumber);
      if (phoneError) {
        return res.status(400).json({
          message: phoneError,
          field: 'phoneNumber',
        });
      }

      const passwordError = validatePassword(password);
      if (passwordError) {
        return res.status(400).json({
          message: passwordError,
          field: 'password',
        });
      }

      const campaignError = validateCampaignId(campaignID);
      if (campaignError) {
        return res.status(400).json({
          message: campaignError,
          field: 'campaignID',
        });
      }

      const normalizedEmail = String(email).trim().toLowerCase();
      const normalizedFullName = normalizeSpaces(fullName);

      const result = await authService.signupPilgrim({
        pilgrimID: String(pilgrimID).trim(),
        fullName: normalizedFullName,
        email: normalizedEmail,
        phoneNumber: String(phoneNumber).trim(),
        password: String(password),
        campaignID: Number(campaignID),
      });

      return res.status(201).json(result);
    } catch (error) {
      return this._handleSignupError(error, res, 'pilgrim');
    }
  }

  async signupProvider(req, res) {
    try {
      const {
        providerID,
        fullName,
        email,
        phoneNumber,
        password,
      } = req.body;

      const providerIdError = validateNumericId(providerID, 'Provider ID');
      if (providerIdError) {
        return res.status(400).json({
          message: providerIdError,
          field: 'providerID',
        });
      }

      const fullNameError = validateFullName(fullName);
      if (fullNameError) {
        return res.status(400).json({
          message: fullNameError,
          field: 'fullName',
        });
      }

      const emailError = validateEmail(email);
      if (emailError) {
        return res.status(400).json({
          message: emailError,
          field: 'email',
        });
      }

      const phoneError = validatePhoneNumber(phoneNumber);
      if (phoneError) {
        return res.status(400).json({
          message: phoneError,
          field: 'phoneNumber',
        });
      }

      const passwordError = validatePassword(password);
      if (passwordError) {
        return res.status(400).json({
          message: passwordError,
          field: 'password',
        });
      }

      const normalizedEmail = String(email).trim().toLowerCase();
      const normalizedFullName = normalizeSpaces(fullName);

      const result = await authService.signupProvider({
        providerID: String(providerID).trim(),
        fullName: normalizedFullName,
        email: normalizedEmail,
        phoneNumber: String(phoneNumber).trim(),
        password: String(password),
      });

      return res.status(201).json(result);
    } catch (error) {
      return this._handleSignupError(error, res, 'provider');
    }
  }
}

module.exports = new AuthController();