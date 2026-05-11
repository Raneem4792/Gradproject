const express = require('express');
const router = express.Router();
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

router.get('/ai-recommended/:pilgrimID', async (req, res) => {
  try {
    const { pilgrimID } = req.params;
    const language = req.query.language || req.query.lang || 'en';
    const isArabic = String(language).toLowerCase().startsWith('ar');

    const [healthRows] = await db.query(
      'SELECT * FROM health_profile WHERE pilgrimID = ?',
      [pilgrimID]
    );

    if (healthRows.length === 0) {
      return res.json({
        needsProfile: true,
        message: isArabic
          ? 'يرجى إكمال الملف الصحي أولاً'
          : 'Please complete your health profile',
        data: [],
      });
    }

    const [meals] = await db.query(
      `
      SELECT 
        m.mealID,

        m.mealName,
        m.mealName_ar,
        m.mealName_en,

        m.mealType,
        m.mealType_ar,
        m.mealType_en,

        m.description,
        m.description_ar,
        m.description_en,

        m.protein,
        m.carbohydrates,
        m.fat,
        m.calories,
        m.image,
        m.providerID,
        p.fullName AS providerName
      FROM pilgrim pi
      JOIN campaign c ON pi.campaignID = c.campaignID
      JOIN meal m ON c.providerID = m.providerID
      LEFT JOIN provider p ON m.providerID = p.providerID
      WHERE pi.pilgrimID = ?
      ORDER BY m.mealID DESC
      `,
      [pilgrimID]
    );

    if (meals.length === 0) {
      return res.json([]);
    }

    const healthProfile = healthRows[0];

    const mealsForAI = meals.map((meal) => ({
      mealID: meal.mealID,
      mealName: pickMealName(meal, isArabic),
      mealType: pickMealType(meal, isArabic),
      description: pickMealDescription(meal, isArabic),
      protein: meal.protein,
      carbohydrates: meal.carbohydrates,
      fat: meal.fat,
      calories: meal.calories,
    }));

    const prompt = `
You are a nutrition assistant for pilgrims.

Pilgrim health profile:
${JSON.stringify(healthProfile)}

Available meals:
${JSON.stringify(mealsForAI)}

Based on the health profile, recommend the most suitable meals only.
Only recommend meals from the Available meals list.
Do not invent meal IDs.

Return JSON only in this exact format:
{
  "recommendations": [
    {
      "mealID": 1,
      "reason": "Suitable because it matches the pilgrim health profile"
    }
  ]
}

Language rule:
- Write the reason in ${isArabic ? 'Arabic' : 'English'}.
`;

    const completion = await openai.chat.completions.create({
      model: 'gpt-4.1-mini',
      messages: [
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: 0.2,
      response_format: { type: 'json_object' },
    });

    let aiResponse = completion.choices[0].message.content.trim();

    aiResponse = aiResponse
      .replace(/```json/g, '')
      .replace(/```/g, '')
      .trim();

    const parsed = JSON.parse(aiResponse);

    const recommendations = parsed.recommendations || [];

    const recommendedMeals = recommendations
      .map((rec) => {
        const meal = meals.find(
          (m) => Number(m.mealID) === Number(rec.mealID)
        );

        if (!meal) return null;

        return {
          ...meal,

          // القديم نخليه عشان الفرونت القديم ما ينكسر
          mealName:
            meal.mealName ||
            meal.mealName_en ||
            meal.mealName_ar ||
            '',

          mealType:
            meal.mealType ||
            meal.mealType_en ||
            meal.mealType_ar ||
            '',

          description:
            meal.description ||
            meal.description_en ||
            meal.description_ar ||
            '',

          // الجديد
          mealName_ar:
            meal.mealName_ar ||
            meal.mealName ||
            meal.mealName_en ||
            '',

          mealName_en:
            meal.mealName_en ||
            meal.mealName ||
            meal.mealName_ar ||
            '',

          mealType_ar:
            meal.mealType_ar ||
            meal.mealType ||
            meal.mealType_en ||
            '',

          mealType_en:
            meal.mealType_en ||
            meal.mealType ||
            meal.mealType_ar ||
            '',

          description_ar:
            meal.description_ar ||
            meal.description ||
            meal.description_en ||
            '',

          description_en:
            meal.description_en ||
            meal.description ||
            meal.description_ar ||
            '',

          isHealthMatched: true,
          aiReason: rec.reason,
        };
      })
      .filter(Boolean);

    return res.json(recommendedMeals);
  } catch (error) {
    console.error('AI Meal Recommendation Error:', error);

    return res.status(500).json({
      message: 'AI recommendation failed',
      error: error.message,
    });
  }
});

module.exports = router;