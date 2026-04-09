const CampaignService = require('../services/CampaignService');

exports.getCampaignsByProvider = async (req, res) => {
  try {
    const { providerID } = req.params;
    const results = await CampaignService.getCampaignsByProvider(providerID);
    return res.status(200).json(results);
  } catch (err) {
    console.error('Error fetching campaigns:', err);
    return res.status(500).json({ error: 'Database error' });
  }
};

exports.createCampaign = async (req, res) => {
  try {
    const {
      campaignName,
      campaignNumber,
      numberOfPilgrims,
      arrivalDetails,
      providerID,
    } = req.body;

    if (
      !campaignName ||
      !campaignNumber ||
      numberOfPilgrims == null ||
      !arrivalDetails ||
      !providerID
    ) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const result = await CampaignService.createCampaign(req.body);

    return res.status(201).json({
      message: 'Campaign created successfully',
      campaignID: result.insertId,
    });
  } catch (err) {
    console.error('Error creating campaign:', err);
    return res.status(500).json({ error: 'Database error' });
  }
};

exports.updateCampaign = async (req, res) => {
  try {
    const { campaignID } = req.params;
    const {
      campaignName,
      campaignNumber,
      numberOfPilgrims,
      arrivalDetails,
    } = req.body;

    if (
      !campaignName ||
      !campaignNumber ||
      numberOfPilgrims == null ||
      !arrivalDetails
    ) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    await CampaignService.updateCampaign(campaignID, req.body);

    return res.status(200).json({ message: 'Campaign updated successfully' });
  } catch (err) {
    console.error('Error updating campaign:', err);
    return res.status(500).json({ error: 'Database error' });
  }
};

exports.deleteCampaign = async (req, res) => {
  try {
    const { campaignID } = req.params;
    await CampaignService.deleteCampaign(campaignID);
    return res.status(200).json({ message: 'Campaign deleted successfully' });
  } catch (err) {
    console.error('Error deleting campaign:', err);
    return res.status(500).json({ error: 'Database error' });
  }
};