const db = require('../config/db');
const Meal = require('../models/Meal');

class MealService {
  _normalizeMealRow(row, req) {
    const baseUrl = `${req.protocol}://${req.get('host')}`;

    let imagePath = row.image || '';

    if (imagePath && imagePath.startsWith('/uploads')) {
      imagePath = `${baseUrl}${imagePath}`;
    }

    return Meal.fromRow({
      ...row,
      image: imagePath,

      // fallback عشان لو فيه بيانات قديمة
      mealName: row.mealName || row.mealName_en || row.mealName_ar || '',
      mealType: row.mealType || row.mealType_en || row.mealType_ar || '',
      description:
        row.description || row.description_en || row.description_ar || '',

      mealName_en: row.mealName_en || row.mealName || '',
      mealName_ar: row.mealName_ar || row.mealName || '',

      mealType_en: row.mealType_en || row.mealType || '',
      mealType_ar: row.mealType_ar || row.mealType || '',

      description_en: row.description_en || row.description || '',
      description_ar: row.description_ar || row.description || '',

      protein: Number(row.protein),
      carbohydrates: Number(row.carbohydrates),
      fat: Number(row.fat),
      calories: Number(row.calories),
    });
  }

  async getAllMeals(req) {
    const [rows] = await db.query(`
      SELECT 
        Meal.mealID,

        Meal.mealName,
        Meal.mealName_en,
        Meal.mealName_ar,

        Meal.mealType,
        Meal.mealType_en,
        Meal.mealType_ar,

        Meal.description,
        Meal.description_en,
        Meal.description_ar,

        Meal.protein,
        Meal.carbohydrates,
        Meal.fat,
        Meal.calories,
        Meal.image,
        Meal.providerID,
        Provider.fullName AS providerName
      FROM Meal
      LEFT JOIN Provider ON Meal.providerID = Provider.providerID
      ORDER BY Meal.mealID DESC
    `);

    return rows.map((row) => this._normalizeMealRow(row, req));
  }

  async createMeal(mealData) {
    const mealNameEn = mealData.mealName_en || mealData.mealName || '';
    const mealNameAr = mealData.mealName_ar || mealData.mealName || '';

    const mealTypeEn = mealData.mealType_en || mealData.mealType || '';
    const mealTypeAr = mealData.mealType_ar || mealData.mealType || '';

    const descriptionEn = mealData.description_en || mealData.description || '';
    const descriptionAr = mealData.description_ar || mealData.description || '';

    // الحقول القديمة نخزن فيها الإنجليزي كـ default
    const mealName = mealData.mealName || mealNameEn || mealNameAr;
    const mealType = mealData.mealType || mealTypeEn || mealTypeAr;
    const description =
      mealData.description || descriptionEn || descriptionAr;

    const sql = `
      INSERT INTO Meal
      (
        mealName,
        mealName_en,
        mealName_ar,

        mealType,
        mealType_en,
        mealType_ar,

        description,
        description_en,
        description_ar,

        protein,
        carbohydrates,
        fat,
        calories,
        image,
        providerID
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const params = [
      mealName,
      mealNameEn,
      mealNameAr,

      mealType,
      mealTypeEn,
      mealTypeAr,

      description,
      descriptionEn,
      descriptionAr,

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
    const mealNameEn = mealData.mealName_en || mealData.mealName || '';
    const mealNameAr = mealData.mealName_ar || mealData.mealName || '';

    const mealTypeEn = mealData.mealType_en || mealData.mealType || '';
    const mealTypeAr = mealData.mealType_ar || mealData.mealType || '';

    const descriptionEn = mealData.description_en || mealData.description || '';
    const descriptionAr = mealData.description_ar || mealData.description || '';

    const mealName = mealData.mealName || mealNameEn || mealNameAr;
    const mealType = mealData.mealType || mealTypeEn || mealTypeAr;
    const description =
      mealData.description || descriptionEn || descriptionAr;

    const sql = `
      UPDATE Meal SET
        mealName = ?,
        mealName_en = ?,
        mealName_ar = ?,

        mealType = ?,
        mealType_en = ?,
        mealType_ar = ?,

        description = ?,
        description_en = ?,
        description_ar = ?,

        protein = ?,
        carbohydrates = ?,
        fat = ?,
        calories = ?,
        image = ?
      WHERE mealID = ?
    `;

    const params = [
      mealName,
      mealNameEn,
      mealNameAr,

      mealType,
      mealTypeEn,
      mealTypeAr,

      description,
      descriptionEn,
      descriptionAr,

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

  async getMealsByProvider(providerID, req) {
    const [rows] = await db.query(
      `
      SELECT 
        Meal.mealID,

        Meal.mealName,
        Meal.mealName_en,
        Meal.mealName_ar,

        Meal.mealType,
        Meal.mealType_en,
        Meal.mealType_ar,

        Meal.description,
        Meal.description_en,
        Meal.description_ar,

        Meal.protein,
        Meal.carbohydrates,
        Meal.fat,
        Meal.calories,
        Meal.image,
        Meal.providerID,
        Provider.fullName AS providerName
      FROM Meal
      LEFT JOIN Provider ON Meal.providerID = Provider.providerID
      WHERE Meal.providerID = ?
      ORDER BY Meal.mealID DESC
      `,
      [providerID]
    );

    return rows.map((row) => this._normalizeMealRow(row, req));
  }

  async getMealsByPilgrimCampaign(pilgrimID, req) {
    const [rows] = await db.query(
      `
      SELECT 
        Meal.mealID,

        Meal.mealName,
        Meal.mealName_en,
        Meal.mealName_ar,

        Meal.mealType,
        Meal.mealType_en,
        Meal.mealType_ar,

        Meal.description,
        Meal.description_en,
        Meal.description_ar,

        Meal.protein,
        Meal.carbohydrates,
        Meal.fat,
        Meal.calories,
        Meal.image,
        Meal.providerID,
        Provider.fullName AS providerName
      FROM Pilgrim
      JOIN Campaign ON Pilgrim.campaignID = Campaign.campaignID
      JOIN Meal ON Campaign.providerID = Meal.providerID
      LEFT JOIN Provider ON Meal.providerID = Provider.providerID
      WHERE Pilgrim.pilgrimID = ?
      ORDER BY Meal.mealID DESC
      `,
      [pilgrimID]
    );

    return rows.map((row) => this._normalizeMealRow(row, req));
  }
}

module.exports = new MealService();