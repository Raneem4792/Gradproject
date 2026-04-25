const express = require('express');
const router = express.Router();
const aiDashboardController = require('../controllers/aiDashboardController');

router.post('/ai-dashboard-analysis', aiDashboardController.getProviderAnalysis);

module.exports = router;