const express = require('express');
const router = express.Router();

const {
  getProviderHomeData,
  getProviderProfile,
  updateProviderProfile,
  getProviderProfileSummary,
} = require('../controllers/providerController');


router.get('/home/:providerID', getProviderHomeData);

router.get('/:providerID', getProviderProfile);

router.post('/update', updateProviderProfile);

router.get('/profile-summary/:providerID', getProviderProfileSummary);

module.exports = router;