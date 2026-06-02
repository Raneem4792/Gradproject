const db = require('../config/db');
const mealService = require('../services/MealService');
const {
  createAdminNotification,
} = require('../services/adminService');

const cleanText = (value) => {
  if (value === undefined || value === null) return '';
  return String(value).trim();
};

const isValidShortText = (value) => {
  /*
    يسمح بـ:
    - عربي
    - إنجليزي
    - أرقام
    - مسافات
    - رموز بسيطة طبيعية للأسماء مثل: - _ / ( ) . ,
  */
  const regex = /^[\u0600-\u06FFa-zA-Z0-9\s.,'’()\-_/]+$/;
  return regex.test(value);
};

const isValidDescription = (value) => {
  /*
    الوصف نسمح فيه بعلامات أكثر شوي:
    . , ! ? : " ' - _ / ( ) والفواصل العربية
    ونمنع رموز مزعجة أو خطيرة مثل:
    < > { } [ ] ; ` | @ # $ % ^ * =
  */
  const regex = /^[\u0600-\u06FFa-zA-Z0-9\s.,'’"()\-_/!?،؛:]+$/;
  return regex.test(value);
};

const isValidNumber = (value) => {
  if (value === undefined || value === null || value === '') return false;

  const number = Number(value);

  return Number.isFinite(number) && number >= 0;
};

const validateMealData = (mealData, { isUpdate = false } = {}) => {
  const errors = [];

  const mealNameEn = cleanText(mealData.mealName_en || mealData.mealName);
  const mealNameAr = cleanText(mealData.mealName_ar);

  const mealTypeEn = cleanText(mealData.mealType_en || mealData.mealType);
  const mealTypeAr = cleanText(mealData.mealType_ar);

  const descriptionEn = cleanText(
    mealData.description_en || mealData.description
  );
  const descriptionAr = cleanText(mealData.description_ar);

  const providerID = cleanText(mealData.providerID);

  if (!mealNameEn && !mealNameAr) {
    errors.push('Meal name is required');
  }

  if (mealNameEn && mealNameEn.length > 100) {
    errors.push('English meal name must be less than 100 characters');
  }

  if (mealNameAr && mealNameAr.length > 100) {
    errors.push('Arabic meal name must be less than 100 characters');
  }

  if (mealNameEn && !isValidShortText(mealNameEn)) {
    errors.push('English meal name contains invalid characters');
  }

  if (mealNameAr && !isValidShortText(mealNameAr)) {
    errors.push('Arabic meal name contains invalid characters');
  }

  if (!mealTypeEn && !mealTypeAr) {
    errors.push('Meal type is required');
  }

  if (mealTypeEn && mealTypeEn.length > 50) {
    errors.push('English meal type must be less than 50 characters');
  }

  if (mealTypeAr && mealTypeAr.length > 50) {
    errors.push('Arabic meal type must be less than 50 characters');
  }

  if (mealTypeEn && !isValidShortText(mealTypeEn)) {
    errors.push('English meal type contains invalid characters');
  }

  if (mealTypeAr && !isValidShortText(mealTypeAr)) {
    errors.push('Arabic meal type contains invalid characters');
  }

  if (!descriptionEn && !descriptionAr) {
    errors.push('Description is required');
  }

  if (descriptionEn && descriptionEn.length > 1000) {
    errors.push('English description must be less than 1000 characters');
  }

  if (descriptionAr && descriptionAr.length > 1000) {
    errors.push('Arabic description must be less than 1000 characters');
  }

  if (descriptionEn && !isValidDescription(descriptionEn)) {
    errors.push('English description contains invalid characters');
  }

  if (descriptionAr && !isValidDescription(descriptionAr)) {
    errors.push('Arabic description contains invalid characters');
  }

  if (!isValidNumber(mealData.protein)) {
    errors.push('Protein must be a valid positive number');
  }

  if (!isValidNumber(mealData.carbohydrates)) {
    errors.push('Carbohydrates must be a valid positive number');
  }

  if (!isValidNumber(mealData.fat)) {
    errors.push('Fat must be a valid positive number');
  }

  if (!isValidNumber(mealData.calories)) {
    errors.push('Calories must be a valid positive number');
  }

  if (!isUpdate && !providerID) {
    errors.push('Provider ID is required');
  }

  return errors;
};

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
        mealName: cleanText(req.body.mealName),
        mealName_en: cleanText(req.body.mealName_en),
        mealName_ar: cleanText(req.body.mealName_ar),

        mealType: cleanText(req.body.mealType),
        mealType_en: cleanText(req.body.mealType_en),
        mealType_ar: cleanText(req.body.mealType_ar),

        description: cleanText(req.body.description),
        description_en: cleanText(req.body.description_en),
        description_ar: cleanText(req.body.description_ar),

        protein: req.body.protein,
        carbohydrates: req.body.carbohydrates,
        fat: req.body.fat,
        calories: req.body.calories,

        providerID: cleanText(req.body.providerID),

        image: req.file
          ? `/uploads/meals/${req.file.filename}`
          : cleanText(req.body.existingImage),
      };

      const validationErrors = validateMealData(mealData);

      if (validationErrors.length > 0) {
        return res.status(400).json({
          message: 'Invalid meal data',
          errors: validationErrors,
        });
      }

      const result = await mealService.createMeal(mealData);
      
      const mealNameAr =
        mealData.mealName_ar || mealData.mealName || mealData.mealName_en || '';

      const mealNameEn =
        mealData.mealName_en || mealData.mealName || mealData.mealName_ar || '';

      await createAdminNotification({
        title: 'New Meal',
        title_ar: 'وجبة جديدة',
        title_en: 'New Meal',

        notificationType: 'meal_created',

        messageContent: `New meal added: ${mealNameEn}`,
        messageContent_ar: `تمت إضافة وجبة جديدة: ${mealNameAr}`,
        messageContent_en: `New meal added: ${mealNameEn}`,
      });


      const [pilgrimRows] = await db.query(
        `
      SELECT p.pilgrimID
      FROM pilgrim p
      JOIN campaign c ON p.campaignID = c.campaignID
      WHERE c.providerID = ?
      `,
        [mealData.providerID]
      );

      const titleAr = 'تمت إضافة وجبة جديدة';
      const titleEn = 'New meal added';

      const messageAr = `تمت إضافة وجبة جديدة: ${mealNameAr}`;
      const messageEn = `A new meal has been added: ${mealNameEn}`;

      for (const pilgrim of pilgrimRows) {
        await db.query(
          `
        INSERT INTO notification
        (
          title,
          title_ar,
          title_en,
          notificationType,
          messageContent,
          messageContent_ar,
          messageContent_en,
          recipientUserID,
          recipientType
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `,
          [
            titleEn,
            titleAr,
            titleEn,
            'meal',
            messageEn,
            messageAr,
            messageEn,
            pilgrim.pilgrimID,
            'pilgrim',
          ]
        );
      }

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
        mealName: cleanText(req.body.mealName),
        mealName_en: cleanText(req.body.mealName_en),
        mealName_ar: cleanText(req.body.mealName_ar),

        mealType: cleanText(req.body.mealType),
        mealType_en: cleanText(req.body.mealType_en),
        mealType_ar: cleanText(req.body.mealType_ar),

        description: cleanText(req.body.description),
        description_en: cleanText(req.body.description_en),
        description_ar: cleanText(req.body.description_ar),

        protein: req.body.protein,
        carbohydrates: req.body.carbohydrates,
        fat: req.body.fat,
        calories: req.body.calories,

        image: req.file
          ? `/uploads/meals/${req.file.filename}`
          : cleanText(req.body.existingImage),
      };

      const validationErrors = validateMealData(updateData, { isUpdate: true });

      if (validationErrors.length > 0) {
        return res.status(400).json({
          message: 'Invalid meal data',
          errors: validationErrors,
        });
      }

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

  async getMealsByProvider(req, res) {
    try {
      const { providerID } = req.params;

      const meals = await mealService.getMealsByProvider(providerID, req);

      return res.status(200).json(meals);
    } catch (error) {
      console.error('Get provider meals error:', error);
      return res.status(500).json({
        message: 'Failed to load provider meals',
      });
    }
  }

  async getMealsByPilgrimCampaign(req, res) {
    try {
      const { pilgrimID } = req.params;

      const meals = await mealService.getMealsByPilgrimCampaign(pilgrimID, req);

      return res.status(200).json(meals);
    } catch (error) {
      console.error('Get campaign meals error:', error);
      return res.status(500).json({
        message: 'Failed to load campaign meals',
      });
    }
  }
}

module.exports = new MealController();