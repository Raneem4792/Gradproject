const db = require('../config/db');
const Meal = require('../models/Meal');

class MealService {
    // 1. جلب كل الوجبات (موجود عندك مسبقاً)
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

    // 2. إضافة وجبة جديدة (F-3.1 / AC9.1)
    async createMeal(mealData) {
        const sql = `
            INSERT INTO Meal 
            (mealName, mealType, description, protein, carbohydrates, fat, calories, image, providerID) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        const params = [
            mealData.mealName, mealData.mealType, mealData.description,
            mealData.protein, mealData.carbohydrates, mealData.fat,
            mealData.calories, mealData.image, mealData.providerID
        ];

        const [result] = await db.query(sql, params);
        return result; // يحتوي على insertId للوجبة الجديدة
    }

    // 3. تعديل وجبة موجودة (F-3.2 / AC3.2.1)
    async updateMeal(id, mealData) {
        const sql = `
            UPDATE Meal SET 
            mealName = ?, mealType = ?, description = ?, protein = ?, 
            carbohydrates = ?, fat = ?, calories = ?, image = ?
            WHERE mealID = ?
        `;
        const params = [
            mealData.mealName, mealData.mealType, mealData.description,
            mealData.protein, mealData.carbohydrates, mealData.fat,
            mealData.calories, mealData.image, id
        ];

        const [result] = await db.query(sql, params);
        return result;
    }

    // 4. حذف وجبة (F-3.3 / AC3.3.1)
    async deleteMeal(id) {
        const sql = "DELETE FROM Meal WHERE mealID = ?";
        const [result] = await db.query(sql, [id]);
        return result;
    }
}

module.exports = new MealService();