const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');

router.post('/', (req, res) => orderController.createOrder(req, res));

router.get('/pilgrim/:pilgrimID', (req, res) =>
  orderController.getOrdersByPilgrim(req, res)
);

router.get('/provider/:providerID/campaigns', (req, res) =>
  orderController.getCampaignsByProvider(req, res)
);

router.get('/provider/:providerID', (req, res) =>
  orderController.getOrdersByProvider(req, res)
);

module.exports = router;