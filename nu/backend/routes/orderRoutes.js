const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');

// POST create order
router.post('/', (req, res) => orderController.createOrder(req, res));

// GET orders by pilgrim
router.get('/pilgrim/:pilgrimID', (req, res) =>
  orderController.getOrdersByPilgrim(req, res)
);

module.exports = router;