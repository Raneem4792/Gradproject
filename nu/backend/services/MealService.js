const db = require('../config/db');
const Meal = require('../models/Meal');

class MealService {
    async getAllMeals() {
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

        return rows.map((row) => {
            return Meal.fromRow({
                ...row,
                protein: Number(row.protein),
                carbohydrates: Number(row.carbohydrates),
                fat: Number(row.fat),
                calories: Number(row.calories),
            });
        });
    }

    
}

module.exports = new MealService();