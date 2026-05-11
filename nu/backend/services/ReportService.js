const db = require('../config/db');

class ReportService {
    async getProviderDashboard(providerID, language = 'en') {
        const isArabic = language === 'ar';

        const pickMealName = (row) => {
            if (isArabic) {
                return row.mealName_ar || row.mealName || row.mealName_en || '';
            }

            return row.mealName_en || row.mealName || row.mealName_ar || '';
        };

        const pickMealType = (row) => {
            if (isArabic) {
                return row.mealType_ar || row.mealType || row.mealType_en || '';
            }

            return row.mealType_en || row.mealType || row.mealType_ar || '';
        };

        const text = {
            noWrittenReview: isArabic
                ? 'لا يوجد تقييم مكتوب'
                : 'No written review',

            noReviewsYet: isArabic
                ? 'لا توجد تقييمات بعد'
                : 'No reviews yet',

            acceptedRequests: isArabic
                ? 'الطلبات المقبولة'
                : 'Accepted requests',

            totalCampaigns: isArabic
                ? 'إجمالي الحملات'
                : 'Total campaigns',

            reviewRejectedOrders: isArabic
                ? 'راجع الطلبات المرفوضة والملغاة لتحسين معدل القبول.'
                : 'Review rejected and cancelled orders to improve acceptance.',

            increaseDiabeticMeals: isArabic
                ? 'زد خيارات الوجبات المناسبة لمرضى السكري للطلبات القادمة.'
                : 'Increase diabetic-friendly meal options for upcoming requests.',

            addLowSodiumMeals: isArabic
                ? 'أضف المزيد من الوجبات قليلة الصوديوم لتناسب تفضيلات الحجاج الغذائية.'
                : 'Add more low-sodium meals to match pilgrim dietary preferences.',

            highProteinDemand: isArabic
                ? 'يوجد اهتمام بخيارات عالية البروتين، وفّر وجبات مناسبة لهذا الاحتياج.'
                : 'There is demand for high-protein options. Provide meals that match this need.',

            allergyAwareMeals: isArabic
                ? 'يوجد حجاج لديهم حساسية غذائية، راجع مكونات الوجبات بوضوح.'
                : 'Some pilgrims have food allergies. Make meal ingredients clearly visible.',

            orderStable: isArabic
                ? 'نشاط الطلبات مستقر اليوم.'
                : 'Order activity looks stable today.',

            keepMonitoring: isArabic
                ? 'استمر في متابعة طلبات الوجبات ومراجعة التقييمات بانتظام.'
                : 'Keep monitoring meal demand and review feedback regularly.',

            trendingMeal: (mealName) =>
                isArabic
                    ? `${mealName} عليها طلب مرتفع اليوم. جهّز كميات إضافية.`
                    : `${mealName} is trending today. Prepare extra portions.`,
        };

        const [orders] = await db.query(
            `
      SELECT
        mo.orderID,
        mo.requestDate,
        mo.status,
        mo.pilgrimID,
        mo.mealID,

        m.mealName,
        m.mealName_ar,
        m.mealName_en,

        m.mealType,
        m.mealType_ar,
        m.mealType_en
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
                        ratings.reduce(
                            (sum, item) => sum + Number(item.stars || 0),
                            0
                        ) / totalReviews
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
                ? String(sortedRatings[0].comment || '').trim() || text.noWrittenReview
                : text.noReviewsYet;

        const starsFilled = Math.max(0, Math.min(5, Math.round(averageScore)));

        const mealMap = {};

        for (const order of todayOrders) {
            const key = order.mealID;

            if (!mealMap[key]) {
                mealMap[key] = {
                    mealID: order.mealID,

                    name: pickMealName(order),
                    name_ar: order.mealName_ar || order.mealName || order.mealName_en || '',
                    name_en: order.mealName_en || order.mealName || order.mealName_ar || '',

                    mealType: pickMealType(order),
                    mealType_ar: order.mealType_ar || order.mealType || order.mealType_en || '',
                    mealType_en: order.mealType_en || order.mealType || order.mealType_ar || '',

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

        const containsWord = (value, words) => {
            const textValue = String(value || '').toLowerCase();
            return words.some((word) => textValue.includes(word));
        };

        const diabetesCount = healthRows.filter((h) =>
            containsWord(h.healthConditions, ['diabetes', 'diabetic'])
        ).length;

        const allergiesCount = healthRows.filter(
            (h) => String(h.allergies || '').trim() !== ''
        ).length;

        const lowSodiumCount = healthRows.filter((h) =>
            containsWord(h.dietaryPreferences, [
                'low sodium',
                'low-sodium',
                'low salt',
                'low-salt',
            ])
        ).length;

        const highProteinCount = healthRows.filter((h) =>
            containsWord(h.dietaryPreferences, ['high protein', 'high-protein'])
        ).length;

        const totalProfiles = healthRows.length;

        const healthSnapshot = {
            diabetes:
                totalProfiles > 0
                    ? Math.round((diabetesCount / totalProfiles) * 100)
                    : 0,

            allergies:
                totalProfiles > 0
                    ? Math.round((allergiesCount / totalProfiles) * 100)
                    : 0,

            lowSodium:
                totalProfiles > 0
                    ? Math.round((lowSodiumCount / totalProfiles) * 100)
                    : 0,

            highProtein:
                totalProfiles > 0
                    ? Math.round((highProteinCount / totalProfiles) * 100)
                    : 0,
        };

        const aiSuggestions = [];

        if (mealAcceptance < 70) {
            aiSuggestions.push(text.reviewRejectedOrders);
        }

        if (healthSnapshot.diabetes >= 15) {
            aiSuggestions.push(text.increaseDiabeticMeals);
        }

        if (healthSnapshot.lowSodium >= 10) {
            aiSuggestions.push(text.addLowSodiumMeals);
        }

        if (healthSnapshot.highProtein >= 10) {
            aiSuggestions.push(text.highProteinDemand);
        }

        if (healthSnapshot.allergies >= 10) {
            aiSuggestions.push(text.allergyAwareMeals);
        }

        if (topMeals.length > 0) {
            aiSuggestions.push(text.trendingMeal(topMeals[0].name));
        }

        if (aiSuggestions.length === 0) {
            aiSuggestions.push(text.orderStable);
            aiSuggestions.push(text.keepMonitoring);
        }

        return {
            updatedAt: new Date().toISOString(),

            overview: {
                todayOrders: todayOrders.length,
            },

            kpis: {
                mealAcceptance: {
                    value: mealAcceptance,
                    subtitle: text.acceptedRequests,
                },
                campaigns: {
                    value: campaigns.length,
                    subtitle: text.totalCampaigns,
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