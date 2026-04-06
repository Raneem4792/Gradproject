const orderService = require('../services/OrderService');

class OrderController {
  async createOrder(req, res) {
    try {
      const { mealID, pilgrimID } = req.body;

      if (!mealID || !pilgrimID) {
        return res.status(400).json({
          message: 'mealID and pilgrimID are required',
        });
      }

      const result = await orderService.createOrder(mealID, pilgrimID);

      return res.status(201).json(result);
    } catch (error) {
      console.error('Create order error:', error);
      return res.status(500).json({
        message: 'Failed to create order',
      });
    }
  }

  async getOrdersByPilgrim(req, res) {
    try {
      const { pilgrimID } = req.params;
      const orders = await orderService.getOrdersByPilgrim(pilgrimID);
      return res.status(200).json(orders);
    } catch (error) {
      console.error('Get pilgrim orders error:', error);
      return res.status(500).json({
        message: 'Failed to load orders',
      });
    }
  }

  async getCampaignsByProvider(req, res) {
    try {
      const { providerID } = req.params;
      const campaigns = await orderService.getCampaignsByProvider(providerID);
      return res.status(200).json(campaigns);
    } catch (error) {
      console.error('Get provider campaigns error:', error);
      return res.status(500).json({
        message: 'Failed to load provider campaigns',
      });
    }
  }

  async getOrdersByProvider(req, res) {
    try {
      const { providerID } = req.params;
      const { campaignID } = req.query;

      const orders = await orderService.getOrdersByProvider(
        providerID,
        campaignID ? Number(campaignID) : null
      );

      return res.status(200).json(orders);
    } catch (error) {
      console.error('Get provider orders error:', error);
      return res.status(500).json({
        message: 'Failed to load provider order history',
      });
    }
  }
}

module.exports = new OrderController();