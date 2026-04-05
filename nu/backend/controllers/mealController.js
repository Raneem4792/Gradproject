const mealService = require('../services/MealService');

class MealController {
  async getMeals(req, res) {
    try {
      const meals = await mealService.getAllMeals();
      return res.status(200).json(meals);
    } catch (error) {
      console.error('Get meals error:', error);
      return res.status(500).json({
        message: 'Failed to load meals',
      });
    }
  }

  
}

module.exports = new MealController();