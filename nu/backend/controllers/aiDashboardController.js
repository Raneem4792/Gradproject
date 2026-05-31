const OpenAI = require('openai');
const db = require('../config/db');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const pickByLanguage = (arValue, enValue, oldValue, isArabic) => {
  if (isArabic) {
    return arValue || oldValue || enValue || '';
  }

  return enValue || oldValue || arValue || '';
};

exports.getProviderAnalysis = async (req, res) => {
  try {
    const { providerID, language } = req.body;

    const isArabic = String(language || 'en').toLowerCase().startsWith('ar');

    if (!providerID) {
      return res.status(400).json({
        error: isArabic ? 'رقم المزود مطلوب' : 'Provider ID is required',
      });
    }

    const [orders] = await db.query(
      `
      SELECT 
        mo.orderID,
        mo.requestDate,
        mo.status,

        m.mealID,

        m.mealName,
        m.mealName_en,
        m.mealName_ar,

        m.mealType,
        m.mealType_en,
        m.mealType_ar,

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

        m.mealName,
        m.mealName_en,
        m.mealName_ar
      FROM rate r
      JOIN meal_order mo ON r.orderID = mo.orderID
      JOIN meal m ON mo.mealID = m.mealID
      WHERE m.providerID = ?
      ORDER BY r.reviewDateTime DESC
      `,
      [providerID]
    );

    const ordersText = orders
      .map((order) => {
        const mealName = pickByLanguage(
          order.mealName_ar,
          order.mealName_en,
          order.mealName,
          isArabic
        );

        const mealType = pickByLanguage(
          order.mealType_ar,
          order.mealType_en,
          order.mealType,
          isArabic
        );

        return `
Order ID: ${order.orderID}
Date: ${order.requestDate}
Status: ${order.status}
Meal: ${mealName}
Type: ${mealType}
Calories: ${order.calories}
Protein: ${order.protein}
Carbohydrates: ${order.carbohydrates}
Fat: ${order.fat}
`;
      })
      .join('\n');

    const ratingsText = ratings
      .map((rate) => {
        const mealName = pickByLanguage(
          rate.mealName_ar,
          rate.mealName_en,
          rate.mealName,
          isArabic
        );

        return `
Rating ID: ${rate.ratingID}
Meal: ${mealName}
Stars: ${rate.stars}
Comment: ${rate.comment || (isArabic ? 'لا يوجد تعليق' : 'No comment')}
Provider Reply: ${rate.providerReply || (isArabic ? 'لا يوجد رد' : 'No reply')}
Review Date: ${rate.reviewDateTime}
`;
      })
      .join('\n');

    const response = await openai.responses.create({
      model: 'gpt-4.1-mini',
      input: `
You are an AI analytics assistant for NUSUQ provider dashboard.

Analyze the provider meals, orders, statuses, and ratings.

Language rule:
- Return the analysis in ${isArabic ? 'Arabic' : 'English'}.
- Keep the section headers exactly as written below in English:
  AI Summary:
  Problems or Risks:
  Recommendations:
- The bullet content must be in ${isArabic ? 'Arabic' : 'English'}.

Provider orders:
${ordersText || (isArabic ? 'لا توجد طلبات' : 'No orders found')}

Provider ratings:
${ratingsText || (isArabic ? 'لا توجد تقييمات' : 'No ratings found')}

Return the analysis in SHORT bullet points.

Rules:
- Each section must have 3-4 bullet points only
- Each bullet point must be VERY SHORT, max 1 line
- No paragraphs at all
- No long explanations
- Use this format exactly:

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
    res.status(500).json({
      error: 'AI dashboard analysis failed',
    });
  }
};