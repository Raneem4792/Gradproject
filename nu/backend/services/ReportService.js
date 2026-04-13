const db = require('../config/db');

class ReportService {
    async getProviderDashboard(providerID) {
        const [orders] = await db.query(
            `
      SELECT
        mo.orderID,
        mo.requestDate,
        mo.status,
        mo.pilgrimID,
        mo.mealID,
        m.mealName,
        m.mealType
      FROM meal_order mo
      JOIN meal m ON mo.mealID = m.mealID
      WHERE m.providerID = ?
      ORDER BY mo.requestDate DESC
      `,
            [providerID]
        );

        const [campaigns] = await db.query(
            `
      SELECT
        campaignID,
        campaignName,
        campaignNumber
      FROM campaign
      WHERE providerID = ?
      ORDER BY campaignID DESC
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
        r.reviewDateTime,
        r.requestDate
      FROM Rate r
      JOIN meal_order mo ON r.orderID = mo.orderID
      JOIN meal m ON mo.mealID = m.mealID
      WHERE m.providerID = ?
      `,
            [providerID]
        );

        const [healthRows] = await db.query(
            `
      SELECT
        hp.pilgrimID,
        hp.dietaryPreferences,
        hp.healthConditions,
        hp.allergies,
        hp.age
      FROM Health_Profile hp
      JOIN pilgrim p ON hp.pilgrimID = p.pilgrimID
      JOIN campaign c ON p.campaignID = c.campaignID
      WHERE c.providerID = ?
      `,
            [providerID]
        );

        const now = new Date();
        const todayStr = now.toISOString().slice(0, 10);

        const todayOrders = orders.filter((o) => {
            const dateStr = new Date(o.requestDate).toISOString().slice(0, 10);
            return dateStr === todayStr;
        });

        const acceptedCount = orders.filter(
            (o) => String(o.status || '').toLowerCase() === 'accepted'
        ).length;

        const totalOrders = orders.length;

        const mealAcceptance =
            totalOrders > 0 ? Math.round((acceptedCount / totalOrders) * 100) : 0;

        const totalReviews = ratings.length;

        const averageScore =
            totalReviews > 0
                ? Number(
                    (
                        ratings.reduce((sum, item) => sum + Number(item.stars || 0), 0) /
                        totalReviews
                    ).toFixed(1)
                )
                : 0;

        const highestScore =
            totalReviews > 0
                ? Math.max(...ratings.map((item) => Number(item.stars || 0)))
                : 0;

        const sortedRatings = [...ratings].sort((a, b) => {
            const dateA = new Date(a.reviewDateTime || a.requestDate || 0).getTime();
            const dateB = new Date(b.reviewDateTime || b.requestDate || 0).getTime();
            return dateB - dateA;
        });

        const latestReview =
            sortedRatings.length > 0
                ? String(sortedRatings[0].comment || '').trim() || 'No written review'
                : 'No reviews yet';

        const starsFilled = Math.max(0, Math.min(5, Math.round(averageScore)));

        const mealMap = {};
        for (const order of todayOrders) {
            const key = order.mealID;
            if (!mealMap[key]) {
                mealMap[key] = {
                    mealID: order.mealID,
                    name: order.mealName,
                    orders: 0,
                };
            }
            mealMap[key].orders += 1;
        }

        const topMeals = Object.values(mealMap)
            .sort((a, b) => b.orders - a.orders)
            .slice(0, 3);

        const demandTrend = [];
        for (let i = 6; i >= 0; i--) {
            const d = new Date();
            d.setDate(now.getDate() - i);

            const dateStr = d.toISOString().slice(0, 10);
            const label = d.toLocaleDateString('en-US', { weekday: 'short' });

            const count = orders.filter((o) => {
                const orderDate = new Date(o.requestDate).toISOString().slice(0, 10);
                return orderDate === dateStr;
            }).length;

            demandTrend.push({
                label,
                value: count,
            });
        }

        const containsWord = (text, words) => {
            const value = String(text || '').toLowerCase();
            return words.some((word) => value.includes(word));
        };

        const diabetesCount = healthRows.filter((h) =>
            containsWord(h.healthConditions, ['diabetes', 'diabetic'])
        ).length;

        const allergiesCount = healthRows.filter(
            (h) => String(h.allergies || '').trim() !== ''
        ).length;

        const lowSodiumCount = healthRows.filter((h) =>
            containsWord(h.dietaryPreferences, ['low sodium', 'low-sodium'])
        ).length;

        const highProteinCount = healthRows.filter((h) =>
            containsWord(h.dietaryPreferences, ['high protein', 'high-protein'])
        ).length;

        const totalProfiles = healthRows.length;

        const healthSnapshot = {
            diabetes:
                totalProfiles > 0 ? Math.round((diabetesCount / totalProfiles) * 100) : 0,
            allergies:
                totalProfiles > 0 ? Math.round((allergiesCount / totalProfiles) * 100) : 0,
            lowSodium:
                totalProfiles > 0 ? Math.round((lowSodiumCount / totalProfiles) * 100) : 0,
            highProtein:
                totalProfiles > 0 ? Math.round((highProteinCount / totalProfiles) * 100) : 0,
        };

        const aiSuggestions = [];

        if (mealAcceptance < 70) {
            aiSuggestions.push(
                'Review rejected and cancelled orders to improve acceptance.'
            );
        }

        if (healthSnapshot.diabetes >= 15) {
            aiSuggestions.push(
                'Increase diabetic-friendly meal options for upcoming requests.'
            );
        }

        if (healthSnapshot.lowSodium >= 10) {
            aiSuggestions.push(
                'Add more low-sodium meals to match pilgrim dietary preferences.'
            );
        }

        if (topMeals.length > 0) {
            aiSuggestions.push(
                `${topMeals[0].name} is trending today. Prepare extra portions.`
            );
        }

        if (aiSuggestions.length === 0) {
            aiSuggestions.push('Order activity looks stable today.');
            aiSuggestions.push('Keep monitoring meal demand and review feedback regularly.');
        }
        console.log('FEEDBACK DEBUG =', {
            averageScore,
            starsFilled,
            totalReviews,
            highestScore,
            latestReview,
        });

        return {
            updatedAt: new Date().toISOString(),
            overview: {
                todayOrders: todayOrders.length,
            },
            kpis: {
                mealAcceptance: {
                    value: mealAcceptance,
                    subtitle: 'Accepted requests',
                },
                campaigns: {
                    value: campaigns.length,
                    subtitle: 'Total campaigns',
                },
            },
            feedback: {
                averageScore,
                starsFilled,
                totalReviews,
                highestScore,
                latestReview,
            },
            demandTrend,
            aiSuggestions: aiSuggestions.slice(0, 3),
            healthSnapshot,
            topMeals,
        };
    }
}

module.exports = new ReportService();