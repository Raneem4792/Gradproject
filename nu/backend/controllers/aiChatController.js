const OpenAI = require('openai');
const db = require('../config/db');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

exports.sendMessage = async (req, res) => {
  try {
    const { message, pilgrimID } = req.body;

    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    if (!pilgrimID) {
      return res.status(400).json({ error: 'Pilgrim ID is required' });
    }

    const [healthRows] = await db.query(
      'SELECT dietaryPreferences, healthConditions, allergies, age FROM health_profile WHERE pilgrimID = ?',
      [pilgrimID]
    );

    const [mealRows] = await db.query(
      'SELECT mealID, mealName, mealType, description, protein, carbohydrates, fat, calories FROM meal'
    );

    const healthProfile = healthRows.length > 0 ? healthRows[0] : null;

    const mealsText = mealRows.map((meal) => {
      return `
Meal ID: ${meal.mealID}
Name: ${meal.mealName}
Type: ${meal.mealType}
Description: ${meal.description}
Protein: ${meal.protein}
Carbohydrates: ${meal.carbohydrates}
Fat: ${meal.fat}
Calories: ${meal.calories}
`;
    }).join('\n');

    const healthText = healthProfile
      ? `
Dietary Preferences: ${healthProfile.dietaryPreferences || 'Not specified'}
Health Conditions: ${healthProfile.healthConditions || 'Not specified'}
Allergies: ${healthProfile.allergies || 'Not specified'}
Age: ${healthProfile.age || 'Not specified'}
`
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
    res.status(500).json({ error: 'AI failed' });
  }
};