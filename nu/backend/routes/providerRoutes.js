const express = require('express');
const router = express.Router();

const {
  getProviderHomeData,
  getProviderProfile,
  updateProviderProfile,
} = require('../controllers/providerController');

// 🔹 Home
router.get('/home/:providerID', getProviderHomeData);

// 🔹 Profile
router.get('/:providerID', getProviderProfile);

// 🔹 Update Profile
router.post('/update', updateProviderProfile);

module.exports = router;