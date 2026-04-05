const healthService = require('../services/HealthService');

class HealthController {
  async getProfile(req, res) {
    try {
      const { pilgrimID } = req.params;

      const profile = await healthService.getProfile(pilgrimID);

      return res.status(200).json(profile ?? {});
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: 'Error loading profile' });
    }
  }

  async saveProfile(req, res) {
    try {
      const result = await healthService.createOrUpdateProfile(req.body);

      return res.status(200).json(result);
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: 'Error saving profile' });
    }
  }
}

module.exports = new HealthController();