const express = require('express');
const router = express.Router();
const reportController = require('../controllers/reportController');

router.get('/provider-dashboard/:providerID', reportController.getProviderDashboard);
router.get('/provider-dashboard/:providerID/pdf', reportController.generateProviderDashboardPdf);

module.exports = router;
