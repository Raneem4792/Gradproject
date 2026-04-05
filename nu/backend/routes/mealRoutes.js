const express = require('express');
const router = express.Router();
const mealController = require('../controllers/mealController');

router.get('/', (req, res) => mealController.getMeals(req, res));

module.exports = router;