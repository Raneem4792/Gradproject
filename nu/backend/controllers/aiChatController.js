const OpenAI = require('openai');
const db = require('../config/db');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const pickMealName = (meal, isArabic) => {
  if (isArabic) {
    return meal.mealName_ar || meal.mealName || meal.mealName_en || '';
  }

  return meal.mealName_en || meal.mealName || meal.mealName_ar || '';
};

const pickMealType = (meal, isArabic) => {
  if (isArabic) {
    return meal.mealType_ar || meal.mealType || meal.mealType_en || '';
  }

  return meal.mealType_en || meal.mealType || meal.mealType_ar || '';
};

const pickMealDescription = (meal, isArabic) => {
  if (isArabic) {
    return meal.description_ar || meal.description || meal.description_en || '';
  }

  return meal.description_en || meal.description || meal.description_ar || '';
};

exports.sendMessage = async (req, res) => {
  try {
    const { message, pilgrimID, language } = req.body;

    const isArabic =
      language === 'ar' ||
      String(message || '').match(/[\u0600-\u06FF]/);

    if (!message) {
      return res.status(400).json({
        error: isArabic ? 'الرسالة مطلوبة' : 'Message is required',
      });
    }

    if (!pilgrimID) {
      return res.status(400).json({
        error: isArabic ? 'رقم الحاج مطلوب' : 'Pilgrim ID is required',
      });
    }

    const [healthRows] = await db.query(
      `
      SELECT
        dietaryPreferences,
        healthConditions,
        allergies,
        age
      FROM health_profile
      WHERE pilgrimID = ?
      `,
      [pilgrimID]
    );

    const [mealRows] = await db.query(
      `
      SELECT
        mealID,

        mealName,
        mealName_ar,
        mealName_en,

        mealType,
        mealType_ar,
        mealType_en,

        description,
        description_ar,
        description_en,

        protein,
        carbohydrates,
        fat,
        calories
      FROM meal
      `
    );

    const healthProfile = healthRows.length > 0 ? healthRows[0] : null;

    const mealsText = mealRows
      .map((meal) => {
        const mealName = pickMealName(meal, isArabic);
        const mealType = pickMealType(meal, isArabic);
        const description = pickMealDescription(meal, isArabic);

        return `
Meal ID: ${meal.mealID}
Name: ${mealName}
Type: ${mealType}
Description: ${description}
Protein: ${meal.protein}
Carbohydrates: ${meal.carbohydrates}
Fat: ${meal.fat}
Calories: ${meal.calories}
`;
      })
      .join('\n');

    const healthText = healthProfile
      ? `
Dietary Preferences: ${healthProfile.dietaryPreferences || 'Not specified'}
Health Conditions: ${healthProfile.healthConditions || 'Not specified'}
Allergies: ${healthProfile.allergies || 'Not specified'}
Age: ${healthProfile.age || 'Not specified'}
`
      : isArabic
        ? 'لا يوجد ملف صحي لهذا الحاج.'
        : 'No health profile found for this pilgrim.';

    const response = await openai.responses.create({
      model: 'gpt-4.1-mini',
      input: `
You are NUSUQ Assistant, an AI chatbot for a Hajj and Umrah meal management app.

Use ONLY the available meals provided below when recommending meals.
Do not invent meal names.
Consider the pilgrim health profile, allergies, age, and dietary preferences.
If the user has allergies or health conditions, be careful and explain why a meal is suitable or not suitable.
Do not provide medical diagnosis. For serious medical advice, tell the user to consult a healthcare professional.

Language rule:
- Reply in ${isArabic ? 'Arabic' : 'English'}.
- Use meal names exactly as listed in the available meals.
- Keep the answer clear, polite, and not too long.

Pilgrim health profile:
${healthText}

Available meals:
${mealsText}

User message:
${message}

Answer clearly and politely.
      `,
    });

    res.json({
      reply: response.output_text,
    });
  } catch (error) {
    console.error('AI Chat Error:', error);
    res.status(500).json({
      error: 'AI failed',
    });
  }
};