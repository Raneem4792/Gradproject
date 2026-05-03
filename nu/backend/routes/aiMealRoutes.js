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

        const [healthRows] = await db.query(
            'SELECT * FROM health_profile WHERE pilgrimID = ?',
            [pilgrimID]
        );

        if (healthRows.length === 0) {
            return res.status(404).json({
                message: 'Health profile not found',
            });
        }

        const [meals] = await db.query(`
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
      FROM meal m
      LEFT JOIN provider p ON m.providerID = p.providerID
    `);

        const healthProfile = healthRows[0];

        const prompt = `
You are a nutrition assistant for pilgrims.

Pilgrim health profile:
${JSON.stringify(healthProfile)}

Available meals:
${JSON.stringify(meals)}

Based on the health profile, recommend the most suitable meals only.

Return JSON only in this exact format:
{
  "recommendations": [
    {
      "mealID": 1,
      "reason": "Suitable because it is low in carbohydrates and fits diabetic diet"
    }
  ]
}
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
        });

        const aiResponse = completion.choices[0].message.content;
        const parsed = JSON.parse(aiResponse);

        const recommendations = parsed.recommendations || [];

        const recommendedMeals = recommendations.map((rec) => {
            const meal = meals.find((m) => m.mealID === rec.mealID);

            if (!meal) return null;

            return {
                ...meal,
                isHealthMatched: true,
                aiReason: rec.reason,
            };
        }).filter(Boolean);

        res.json(recommendedMeals);
    } catch (error) {
        console.error('AI Meal Recommendation Error:', error);
        res.status(500).json({
            message: 'AI recommendation failed',
            error: error.message,
        });
    }
});

module.exports = router;