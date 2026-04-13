const express = require('express');
const router = express.Router();
const reportController = require('../controllers/reportController');

router.get('/provider-dashboard/:providerID', reportController.getProviderDashboard);

module.exports = router;
