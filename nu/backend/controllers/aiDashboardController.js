const OpenAI = require('openai');
const db = require('../config/db');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

exports.getProviderAnalysis = async (req, res) => {
  try {
    const { providerID } = req.body;

    if (!providerID) {
      return res.status(400).json({ error: 'Provider ID is required' });
    }

    const [orders] = await db.query(
      `
      SELECT 
        mo.orderID,
        mo.requestDate,
        mo.status,
        m.mealID,
        m.mealName,
        m.mealType,
        m.calories,
        m.protein,
        m.carbohydrates,
        m.fat
      FROM meal_order mo
      JOIN meal m ON mo.mealID = m.mealID
      WHERE m.providerID = ?
      ORDER BY mo.requestDate DESC
      `,
      [providerID]
    );

    const [ratings] = await db.query(
      `
      SELECT 
        r.ratingID,
        r.orderID,
        r.stars,
        r.comment,
        r.providerReply,
        r.reviewDateTime,
        m.mealName
      FROM rate r
      JOIN meal_order mo ON r.orderID = mo.orderID
      JOIN meal m ON mo.mealID = m.mealID
      WHERE m.providerID = ?
      ORDER BY r.reviewDateTime DESC
      `,
      [providerID]
    );

    const ordersText = orders.map((order) => {
      return `
Order ID: ${order.orderID}
Date: ${order.requestDate}
Status: ${order.status}
Meal: ${order.mealName}
Type: ${order.mealType}
Calories: ${order.calories}
Protein: ${order.protein}
Carbohydrates: ${order.carbohydrates}
Fat: ${order.fat}
`;
    }).join('\n');

    const ratingsText = ratings.map((rate) => {
      return `
Rating ID: ${rate.ratingID}
Meal: ${rate.mealName}
Stars: ${rate.stars}
Comment: ${rate.comment || 'No comment'}
Provider Reply: ${rate.providerReply || 'No reply'}
Review Date: ${rate.reviewDateTime}
`;
    }).join('\n');

    const response = await openai.responses.create({
      model: 'gpt-4.1-mini',
      input: `
You are an AI analytics assistant for NUSUQ provider dashboard.

Analyze the provider meals, orders, statuses, and ratings.

Provider orders:
${ordersText || 'No orders found'}

Provider ratings:
${ratingsText || 'No ratings found'}

Return the analysis in SHORT bullet points.

Rules:
- Each section must have 3-4 bullet points only
- Each bullet point must be VERY SHORT (max 1 line)
- No paragraphs at all
- No long explanations
- Use this format:

AI Summary:
• ...

Problems or Risks:
• ...

Recommendations:
• ...
      `,
    });

    res.json({
      analysis: response.output_text,
    });
  } catch (error) {
    console.error('AI Dashboard Error:', error);
    res.status(500).json({ error: 'AI dashboard analysis failed' });
  }
};