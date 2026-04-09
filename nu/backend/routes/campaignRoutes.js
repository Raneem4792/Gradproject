const express = require('express');
const router = express.Router();
const campaignController = require('../controllers/campaignController');

router.get('/provider/:providerID', campaignController.getCampaignsByProvider);
router.post('/', campaignController.createCampaign);
router.put('/:campaignID', campaignController.updateCampaign);
router.delete('/:campaignID', campaignController.deleteCampaign);

module.exports = router;