const mealService = require('../services/MealService');

class MealController {
  // 1. جلب كل الوجبات
  async getMeals(req, res) {
    try {
      const meals = await mealService.getAllMeals();
      return res.status(200).json(meals);
    } catch (error) {
      console.error('Get meals error:', error);
      return res.status(500).json({ message: 'Failed to load meals' });
    }
  }

  // 2. إضافة وجبة جديدة (F-3.1 / AC9.1)
  async addMeal(req, res) {
    try {
      // استلام البيانات بناءً على الموديل الخاص بكِ
      const mealData = req.body; 
      const result = await mealService.createMeal(mealData);
      
      // AC9.2: تأكيد النجاح وإرجاع البيانات المضافة
      return res.status(201).json({
        message: 'Meal added successfully',
        mealID: result.insertId
      });
    } catch (error) {
      console.error('Add meal error:', error);
      return res.status(500).json({ message: 'Failed to add meal' });
    }
  }

  // 3. تعديل وجبة موجودة (F-3.2 / AC3.2.1)
  async updateMeal(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;
      await mealService.updateMeal(id, updateData);
      
      return res.status(200).json({ message: 'Meal updated successfully' });
    } catch (error) {
      console.error('Update meal error:', error);
      return res.status(500).json({ message: 'Failed to update meal' });
    }
  }

  // 4. حذف وجبة (F-3.3 / AC3.3.1)
  async deleteMeal(req, res) {
    try {
      const { id } = req.params;
      await mealService.deleteMeal(id);
      
      return res.status(200).json({ message: 'Meal deleted successfully' });
    } catch (error) {
      console.error('Delete meal error:', error);
      return res.status(500).json({ message: 'Failed to delete meal' });
    }
  }
}

module.exports = new MealController();