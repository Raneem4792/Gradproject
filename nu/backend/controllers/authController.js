const authService = require('../services/AuthService');

class AuthController {
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

      if (
        !pilgrimID ||
        !fullName ||
        !email ||
        !phoneNumber ||
        !password ||
        !campaignID
      ) {
        return res.status(400).json({
          message: 'All pilgrim fields are required',
        });
      }

      const result = await authService.signupPilgrim({
        pilgrimID,
        fullName,
        email,
        phoneNumber,
        password,
        campaignID,
      });

      return res.status(201).json(result);
    } catch (error) {
      console.error('Signup pilgrim error:', error);

      if (error.message === 'Account already exists') {
        return res.status(409).json({
          message: error.message,
        });
      }

      return res.status(500).json({
        message: 'Server error',
      });
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

      if (!providerID || !fullName || !email || !phoneNumber || !password) {
        return res.status(400).json({
          message: 'All provider fields are required',
        });
      }

      const result = await authService.signupProvider({
        providerID,
        fullName,
        email,
        phoneNumber,
        password,
      });

      return res.status(201).json(result);
    } catch (error) {
      console.error('Signup provider error:', error);

      if (error.message === 'Account already exists') {
        return res.status(409).json({
          message: error.message,
        });
      }

      return res.status(500).json({
        message: 'Server error',
      });
    }
  }
}

module.exports = new AuthController();