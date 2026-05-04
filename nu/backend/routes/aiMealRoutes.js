const express = require('express');
const router = express.Router();
const OpenAI = require('openai');
const db = require('../config/db');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

router.get('/ai-recommended/:pilgrimID', async (req, res) => {
  try {
    const { pilgrimID } = req.params;

    // 1. Get health profile
    const [healthRows] = await db.query(
      'SELECT * FROM health_profile WHERE pilgrimID = ?',
      [pilgrimID]
    );

    // ✅ إذا ما فيه بروفايل
    if (healthRows.length === 0) {
      return res.json({
        needsProfile: true,
        message: 'Please complete your health profile',
        data: [],
      });
    }

    // 2. Get meals from same campaign provider
    const [meals] = await db.query(
      `
      SELECT 
        m.mealID,
        m.mealName,
        m.mealType,
        m.description,
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

    // ✅ إذا ما فيه وجبات
    if (meals.length === 0) {
      return res.json([]);
    }

    const healthProfile = healthRows[0];

    // 3. AI Prompt
    const prompt = `
You are a nutrition assistant for pilgrims.

Pilgrim health profile:
${JSON.stringify(healthProfile)}

Available meals:
${JSON.stringify(meals)}

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
`;

    // 4. Call OpenAI
    const completion = await openai.chat.completions.create({
      model: 'gpt-4.1-mini',
      messages: [
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: 0.2,
      response_format: { type: 'json_object' }, // 🔥 مهم
    });

    // 5. تنظيف الرد + حل مشكلة JSON
    let aiResponse = completion.choices[0].message.content.trim();

    aiResponse = aiResponse
      .replace(/```json/g, '')
      .replace(/```/g, '')
      .trim();

    const parsed = JSON.parse(aiResponse);

    const recommendations = parsed.recommendations || [];

    // 6. مطابقة الوجبات
    const recommendedMeals = recommendations
      .map((rec) => {
        const meal = meals.find(
          (m) => Number(m.mealID) === Number(rec.mealID)
        );

        if (!meal) return null;

        return {
          ...meal,
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