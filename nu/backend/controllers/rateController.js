const rateService = require('../services/RateService');

class RateController {
  async createRate(req, res) {
    try {
      const { orderID, stars, comment } = req.body;

      if (!orderID || !stars) {
        return res.status(400).json({
          message: 'orderID and stars are required',
        });
      }

      if (Number(stars) < 1 || Number(stars) > 5) {
        return res.status(400).json({
          message: 'Stars must be between 1 and 5',
        });
      }

      const result = await rateService.createRate(
        Number(orderID),
        Number(stars),
        comment ?? ''
      );

      return res.status(201).json(result);
    } catch (error) {
      console.error('Create rate error:', error);

      if (
        error.message === 'This order has already been reviewed' ||
        error.message === 'Order not found'
      ) {
        return res.status(400).json({
          message: error.message,
        });
      }

      return res.status(500).json({
        message: 'Failed to submit review',
      });
    }
  }

  async getRateByOrder(req, res) {
    try {
      const { orderID } = req.params;

      const rate = await rateService.getRateByOrder(Number(orderID));

      if (!rate) {
        return res.status(404).json({
          message: 'Review not found',
        });
      }

      return res.status(200).json(rate);
    } catch (error) {
      console.error('Get rate error:', error);
      return res.status(500).json({
        message: 'Failed to load review',
      });
    }
  }
}

module.exports = new RateController();