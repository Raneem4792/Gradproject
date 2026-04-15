const mealService = require('../services/MealService');

class MealController {
  async getMeals(req, res) {
    try {
      const meals = await mealService.getAllMeals(req);
      return res.status(200).json(meals);
    } catch (error) {
      console.error('Get meals error:', error);
      return res.status(500).json({ message: 'Failed to load meals' });
    }
  }

  async addMeal(req, res) {
    try {
      const mealData = {
        mealName: req.body.mealName,
        mealType: req.body.mealType,
        description: req.body.description,
        protein: req.body.protein,
        carbohydrates: req.body.carbohydrates,
        fat: req.body.fat,
        calories: req.body.calories,
        providerID: req.body.providerID,
        image: req.file
          ? `/uploads/meals/${req.file.filename}`
          : (req.body.existingImage || ''),
      };

      const result = await mealService.createMeal(mealData);

      return res.status(201).json({
        message: 'Meal added successfully',
        mealID: result.insertId,
      });
    } catch (error) {
      console.error('Add meal error:', error);
      return res.status(500).json({
        message: error.message || 'Failed to add meal',
      });
    }
  }

  async updateMeal(req, res) {
    try {
      const { id } = req.params;

      const updateData = {
        mealName: req.body.mealName,
        mealType: req.body.mealType,
        description: req.body.description,
        protein: req.body.protein,
        carbohydrates: req.body.carbohydrates,
        fat: req.body.fat,
        calories: req.body.calories,
        image: req.file
          ? `/uploads/meals/${req.file.filename}`
          : (req.body.existingImage || ''),
      };

      await mealService.updateMeal(id, updateData);

      return res.status(200).json({
        message: 'Meal updated successfully',
      });
    } catch (error) {
      console.error('Update meal error:', error);
      return res.status(500).json({
        message: error.message || 'Failed to update meal',
      });
    }
  }

  async deleteMeal(req, res) {
    try {
      const { id } = req.params;
      await mealService.deleteMeal(id);

      return res.status(200).json({
        message: 'Meal deleted successfully',
      });
    } catch (error) {
      console.error('Delete meal error:', error);
      return res.status(500).json({
        message: 'Failed to delete meal',
      });
    }
  }
}

module.exports = new MealController();