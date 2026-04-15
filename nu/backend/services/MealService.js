const db = require('../config/db');
const Meal = require('../models/Meal');

class MealService {
  async getAllMeals(req) {
    const [rows] = await db.query(`
      SELECT 
        Meal.mealID,
        Meal.mealName,
        Meal.mealType,
        Meal.description,
        Meal.protein,
        Meal.carbohydrates,
        Meal.fat,
        Meal.calories,
        Meal.image,
        Meal.providerID,
        Provider.fullName AS providerName
      FROM Meal
      LEFT JOIN Provider ON Meal.providerID = Provider.providerID
    `);

    const baseUrl = `${req.protocol}://${req.get('host')}`;

    return rows.map((row) => {
      let imagePath = row.image || '';

      if (imagePath && imagePath.startsWith('/uploads')) {
        imagePath = `${baseUrl}${imagePath}`;
      }

      return Meal.fromRow({
        ...row,
        image: imagePath,
        protein: Number(row.protein),
        carbohydrates: Number(row.carbohydrates),
        fat: Number(row.fat),
        calories: Number(row.calories),
      });
    });
  }

  async createMeal(mealData) {
    const sql = `
      INSERT INTO Meal
      (mealName, mealType, description, protein, carbohydrates, fat, calories, image, providerID)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const params = [
      mealData.mealName,
      mealData.mealType,
      mealData.description,
      mealData.protein,
      mealData.carbohydrates,
      mealData.fat,
      mealData.calories,
      mealData.image,
      mealData.providerID,
    ];

    const [result] = await db.query(sql, params);
    return result;
  }

  async updateMeal(id, mealData) {
    const sql = `
      UPDATE Meal SET
      mealName = ?,
      mealType = ?,
      description = ?,
      protein = ?,
      carbohydrates = ?,
      fat = ?,
      calories = ?,
      image = ?
      WHERE mealID = ?
    `;

    const params = [
      mealData.mealName,
      mealData.mealType,
      mealData.description,
      mealData.protein,
      mealData.carbohydrates,
      mealData.fat,
      mealData.calories,
      mealData.image,
      id,
    ];

    const [result] = await db.query(sql, params);
    return result;
  }

  async deleteMeal(id) {
    const sql = 'DELETE FROM Meal WHERE mealID = ?';
    const [result] = await db.query(sql, [id]);
    return result;
  }
}

module.exports = new MealService();