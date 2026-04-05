const express = require('express');
const router = express.Router();
const rateController = require('../controllers/rateController');

router.post('/', (req, res) => rateController.createRate(req, res));
router.get('/order/:orderID', (req, res) => rateController.getRateByOrder(req, res));

module.exports = router;