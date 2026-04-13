const reportService = require('../services/ReportService');

class ReportController {
    async getProviderDashboard(req, res) {
        try {
            const { providerID } = req.params;

            if (!providerID) {
                return res.status(400).json({
                    message: 'providerID is required',
                });
            }

            const data = await reportService.getProviderDashboard(Number(providerID));

            return res.status(200).json(data);
        } catch (error) {
            console.error('Get provider dashboard error:', error);
            return res.status(500).json({
                message: 'Failed to load dashboard report',
            });
        }
    }
}

module.exports = new ReportController();