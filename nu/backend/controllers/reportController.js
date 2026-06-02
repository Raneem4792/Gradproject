const PDFDocument = require('pdfkit');
const reportService = require('../services/ReportService');

class ReportController {
    async getProviderDashboard(req, res) {
        try {
            const { providerID } = req.params;
            const language = req.query.lang || 'en';

            if (!providerID) {
                return res.status(400).json({ message: 'providerID is required' });
            }

            const data = await reportService.getProviderDashboard(providerID, language);
            return res.status(200).json(data);
        } catch (error) {
            console.error('Get provider dashboard error:', error);
            return res.status(500).json({ message: 'Failed to load dashboard report' });
        }
    }

    async generateProviderDashboardPdf(req, res) {
        try {
            const { providerID } = req.params;
            const language = req.query.lang || 'en';
            const isArabic = language === 'ar';

            if (!providerID) {
                return res.status(400).json({ message: 'providerID is required' });
            }

            const data = await reportService.getProviderDashboard(providerID, language);

            const doc = new PDFDocument({
                margin: 36,
                size: 'A4',
            });

            const fileName = `provider-dashboard-report-${providerID}.pdf`;

            res.setHeader('Content-Type', 'application/pdf');
            res.setHeader('Content-Disposition', `inline; filename="${fileName}"`);

            doc.pipe(res);

            const colors = {
                bg: '#F1F7F4',
                dark: '#052720',
                primary: '#0B4A40',
                primaryMid: '#167062',
                green: '#1E8A72',
                mint: '#A8E7CF',
                softMint: '#E8F7F1',
                gold: '#F0E0C0',
                text: '#1F2937',
                subtext: '#6B7280',
                border: '#D9E6E1',
                white: '#FFFFFF',
                card: '#F9FCFB',
            };

            const t = {
                title: isArabic ? 'الأداء والتقارير' : 'Performance & Reports',
                updated: isArabic ? 'آخر تحديث' : 'Updated',
                dashboardOverview: isArabic ? 'نظرة عامة على لوحة التحكم' : 'Dashboard Overview',
                liveData: isArabic ? 'بيانات مباشرة' : 'Live Data',
                todaysOrders: isArabic ? 'طلبات اليوم' : "Today's Orders",
                campaigns: isArabic ? 'الحملات' : 'Campaigns',
                acceptanceRate: isArabic ? 'معدل القبول' : 'Acceptance Rate',
                mealAcceptance: isArabic ? 'قبول الوجبات' : 'Meal Acceptance',
                acceptedRequests: isArabic ? 'الطلبات المقبولة' : 'Accepted requests',
                feedbackAverage: isArabic ? 'متوسط التقييم' : 'Feedback Average',
                averageRating: isArabic ? 'متوسط التقييم' : 'Average rating',
                aiDashboardInsights: isArabic ? 'تحليلات الذكاء الاصطناعي' : 'AI Dashboard Insights',
                smartAnalysis: isArabic ? 'تحليل ذكي بناءً على الطلبات والتقييمات' : 'Smart analysis based on orders and feedback',
                aiSummary: isArabic ? 'ملخص الذكاء الاصطناعي' : 'AI Summary',
                feedbackRisk: isArabic ? 'تحليل مخاطر التقييمات' : 'Feedback Risk Analysis',
                smartRecommendations: isArabic ? 'توصيات ذكية' : 'Smart Recommendations',
                orderTrend: isArabic ? 'اتجاه الطلبات' : 'Order Trend',
                dailyOrders: isArabic ? 'الطلبات اليومية خلال آخر 7 أيام' : 'Daily orders in the last 7 days',
                feedback: isArabic ? 'التقييمات' : 'Feedback',
                reviews: isArabic ? 'عدد التقييمات' : 'Reviews',
                average: isArabic ? 'المتوسط' : 'Average',
                highest: isArabic ? 'الأعلى' : 'Highest',
                latestReview: isArabic ? 'آخر تقييم' : 'Latest Review',
                healthSnapshot: isArabic ? 'ملخص الحالة الصحية للحجاج' : 'Pilgrim Health Snapshot',
                healthSubtitle: isArabic ? 'مؤشرات صحية وغذائية شائعة' : 'Common dietary and health indicators',
                diabetes: isArabic ? 'السكري' : 'Diabetes',
                allergies: isArabic ? 'الحساسية' : 'Allergies',
                lowSodium: isArabic ? 'قليل الصوديوم' : 'Low Sodium',
                highProtein: isArabic ? 'عالي البروتين' : 'High Protein',
                topMeals: isArabic ? 'أكثر الوجبات طلباً' : 'Top Requested Meals',
                topMealsSubtitle: isArabic ? 'أكثر الوجبات طلباً اليوم' : 'Most ordered meals today',
                orders: isArabic ? 'طلبات' : 'orders',
                noMeals: isArabic ? 'لا توجد طلبات وجبات حتى الآن' : 'No meal requests yet',
                noSuggestions: isArabic ? 'لا توجد توصيات حالياً' : 'No suggestions available',
                noReviews: isArabic ? 'لا توجد تقييمات بعد' : 'No reviews yet',
            };

            const safeText = (value, fallback = '-') => {
                if (value === null || value === undefined) return fallback;
                const str = String(value).trim();
                return str === '' ? fallback : str;
            };

            const pageWidth = doc.page.width;
            const pageHeight = doc.page.height;
            const contentLeft = 36;
            const contentRight = pageWidth - 36;
            const contentWidth = contentRight - contentLeft;

            const formatUpdatedAt = (value) => {
                try {
                    const dt = new Date(value);
                    return `${String(dt.getHours()).padStart(2, '0')}:${String(dt.getMinutes()).padStart(2, '0')}`;
                } catch (_) {
                    return '-';
                }
            };

            const ensureSpace = (height) => {
                if (doc.y + height > pageHeight - 45) {
                    doc.addPage();
                    doc.y = 36;
                }
            };

            const drawPageHeader = () => {
                const x = contentLeft;
                const y = 34;
                const w = contentWidth;
                const h = 88;

                doc
                    .roundedRect(x, y, w, h, 24)
                    .fill(colors.softMint);

                doc
                    .fillColor(colors.dark)
                    .font('Helvetica-Bold')
                    .fontSize(24)
                    .text('NUSUQ Provider Performance Report', x, y + 22, {
                        width: w,
                        align: 'center',
                    });

                doc
                    .fillColor(colors.subtext)
                    .font('Helvetica')
                    .fontSize(10.5)
                    .text(`Provider ID: ${providerID}`, x, y + 55, {
                        width: w,
                        align: 'center',
                    })
                    .text(`Generated at: ${new Date(data.updatedAt).toLocaleString()}`, x, y + 71, {
                        width: w,
                        align: 'center',
                    });

                doc.y = y + h + 28;
            };

            const drawSectionHeader = (title, subtitle) => {
                ensureSpace(45);
                doc
                    .fillColor(colors.text)
                    .font('Helvetica-Bold')
                    .fontSize(14)
                    .text(title, contentLeft, doc.y);

                if (subtitle) {
                    doc.moveDown(0.2);
                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica-Bold')
                        .fontSize(10)
                        .text(subtitle, contentLeft, doc.y);
                }

                doc.moveDown(0.7);
            };

            const drawHeroCard = () => {
                const x = contentLeft;
                const y = doc.y;
                const w = contentWidth;
                const h = 158;

                doc.roundedRect(x, y, w, h, 24).fill(colors.dark);

                doc
                    .circle(x + w - 45, y + 18, 58)
                    .fillOpacity(0.08)
                    .fill(colors.white)
                    .fillOpacity(1);

                doc
                    .circle(x + 25, y + h - 5, 68)
                    .fillOpacity(0.07)
                    .fill(colors.mint)
                    .fillOpacity(1);

                doc
                    .fillColor(colors.white)
                    .font('Helvetica-Bold')
                    .fontSize(15)
                    .text(t.dashboardOverview, x + 18, y + 18);

                doc
                    .roundedRect(x + w - 96, y + 16, 76, 24, 12)
                    .fillOpacity(0.18)
                    .fill(colors.gold)
                    .fillOpacity(1);

                doc
                    .fillColor(colors.gold)
                    .font('Helvetica-Bold')
                    .fontSize(9.5)
                    .text(t.liveData, x + w - 88, y + 23, { width: 60, align: 'center' });

                const metricW = (w - 54) / 2;
                const metricY = y + 54;

                const heroMetric = (mx, title, value, dotColor) => {
                    doc
                        .roundedRect(mx, metricY, metricW, 50, 16)
                        .fillOpacity(0.11)
                        .fill(colors.white)
                        .fillOpacity(1);

                    doc.circle(mx + 16, metricY + 17, 4).fill(dotColor);

                    doc
                        .fillColor('#D7E6E1')
                        .font('Helvetica-Bold')
                        .fontSize(10)
                        .text(title, mx + 28, metricY + 12, { width: metricW - 38 });

                    doc
                        .fillColor(colors.white)
                        .font('Helvetica-Bold')
                        .fontSize(21)
                        .text(String(value), mx + 14, metricY + 27);
                };

                heroMetric(x + 18, t.todaysOrders, data.overview?.todayOrders ?? 0, colors.mint);
                heroMetric(x + 36 + metricW, t.campaigns, data.kpis?.campaigns?.value ?? 0, colors.gold);

                const percent = Number(data.kpis?.mealAcceptance?.value ?? 0);
                const p = Math.max(0, Math.min(1, percent / 100));

                const pillY = y + 118;
                doc
                    .roundedRect(x + 18, pillY, w - 36, 26, 13)
                    .fillOpacity(0.11)
                    .fill(colors.white)
                    .fillOpacity(1);

                doc
                    .fillColor('#D7E6E1')
                    .font('Helvetica-Bold')
                    .fontSize(10)
                    .text(t.acceptanceRate, x + 32, pillY + 8);

                const barX = x + 165;
                const barY = pillY + 10;
                const barW = w - 260;

                doc.roundedRect(barX, barY, barW, 7, 4).fillOpacity(0.12).fill(colors.white).fillOpacity(1);
                doc.roundedRect(barX, barY, barW * p, 7, 4).fill(colors.mint);

                doc
                    .fillColor(colors.white)
                    .font('Helvetica-Bold')
                    .fontSize(11)
                    .text(`${percent}%`, x + w - 72, pillY + 7, { width: 44, align: 'right' });

                doc.y = y + h + 16;
            };

            const drawKpiCards = () => {
                const gap = 12;
                const w = (contentWidth - gap) / 2;
                const h = 76;
                const y = doc.y;

                const kpi = (x, title, value, sub) => {
                    doc.roundedRect(x, y, w, h, 18).fillAndStroke(colors.white, colors.border);

                    doc
                        .roundedRect(x + 14, y + 15, 38, 38, 12)
                        .fill(colors.softMint);

                    doc
                        .fillColor(colors.primary)
                        .font('Helvetica-Bold')
                        .fontSize(16)
                        .text('•', x + 28, y + 23);

                    doc
                        .fillColor(colors.text)
                        .font('Helvetica-Bold')
                        .fontSize(10.5)
                        .text(title, x + 64, y + 13, { width: w - 78 });

                    doc
                        .fillColor(colors.dark)
                        .font('Helvetica-Bold')
                        .fontSize(18)
                        .text(String(value), x + 64, y + 31);

                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica-Bold')
                        .fontSize(9)
                        .text(sub, x + 64, y + 53, { width: w - 78 });
                };

                kpi(
                    contentLeft,
                    t.mealAcceptance,
                    `${data.kpis?.mealAcceptance?.value ?? 0}%`,
                    t.acceptedRequests
                );

                kpi(
                    contentLeft + w + gap,
                    t.feedbackAverage,
                    Number(data.feedback?.averageScore ?? 0).toFixed(1),
                    t.averageRating
                );

                doc.y = y + h + 16;
            };

            const drawAiInsights = () => {
                ensureSpace(145);

                const suggestions = data.aiSuggestions || [];
                const summary =
                    suggestions[0] ||
                    (isArabic
                        ? 'يتم تحليل أداء الطلبات والتقييمات بناءً على بيانات مقدم الخدمة.'
                        : 'Provider performance is analyzed based on orders and feedback data.');

                const risk =
                    data.kpis?.mealAcceptance?.value < 70
                        ? suggestions[0]
                        : isArabic
                            ? 'لا توجد مخاطر واضحة حالياً، لكن يفضل متابعة التقييمات والطلبات بشكل مستمر.'
                            : 'No clear risk is detected now, but feedback and orders should be monitored regularly.';

                const recommendation = suggestions.slice(1).join('\n') || suggestions[0] || t.noSuggestions;

                const x = contentLeft;
                const y = doc.y;
                const w = contentWidth;

                doc.roundedRect(x, y, w, 210, 24).fill(colors.dark);

                doc
                    .fillColor(colors.gold)
                    .font('Helvetica-Bold')
                    .fontSize(15)
                    .text(t.aiDashboardInsights, x + 18, y + 18);

                doc
                    .fillColor('#D7E6E1')
                    .font('Helvetica-Bold')
                    .fontSize(9.5)
                    .text(t.smartAnalysis, x + 18, y + 39);

                const insightCard = (cy, title, content, highlighted = false) => {
                    const fill = highlighted ? colors.gold : colors.white;
                    doc.roundedRect(x + 18, cy, w - 36, 44, 15).fill(fill);

                    doc
                        .fillColor(colors.primary)
                        .font('Helvetica-Bold')
                        .fontSize(10.5)
                        .text(title, x + 32, cy + 8);

                    doc
                        .fillColor(colors.text)
                        .font('Helvetica')
                        .fontSize(9.3)
                        .text(safeText(content), x + 32, cy + 22, {
                            width: w - 64,
                            height: 16,
                            ellipsis: true,
                        });
                };

                insightCard(y + 62, t.aiSummary, summary);
                insightCard(y + 112, t.feedbackRisk, risk);
                insightCard(y + 162, t.smartRecommendations, recommendation, true);

                doc.y = y + 226;
            };

            const drawBarChart = (items) => {
                ensureSpace(210);

                drawSectionHeader(t.orderTrend, t.dailyOrders);

                const x = contentLeft;
                const y = doc.y;
                const w = contentWidth;
                const h = 170;

                doc.roundedRect(x, y, w, h, 20).fillAndStroke(colors.white, colors.border);

                const values = (items || []).map((e) => Number(e.value || 0));
                const maxValue = Math.max(...values, 1);

                const innerX = x + 22;
                const innerY = y + 24;
                const innerW = w - 44;
                const innerH = 100;
                const gap = 13;
                const barW = values.length > 0 ? (innerW - gap * (values.length - 1)) / values.length : 20;

                (items || []).forEach((item, index) => {
                    const value = Number(item.value || 0);
                    const barH = Math.max(10, (value / maxValue) * 86);
                    const bx = innerX + index * (barW + gap);
                    const by = innerY + innerH - barH;

                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica-Bold')
                        .fontSize(9)
                        .text(String(value), bx, by - 14, { width: barW, align: 'center' });

                    doc.roundedRect(bx, by, barW, barH, 9).fill(colors.green);

                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica-Bold')
                        .fontSize(9)
                        .text(safeText(item.label), bx, innerY + innerH + 10, {
                            width: barW,
                            align: 'center',
                        });
                });

                doc.y = y + h + 16;
            };

            const drawFeedbackCard = () => {
                ensureSpace(170);

                drawSectionHeader(t.feedback);

                const x = contentLeft;
                const y = doc.y;
                const w = contentWidth;
                const h = 145;
                const rating = Number(data.feedback?.averageScore ?? 0);
                const starsFilled = Number(data.feedback?.starsFilled ?? 0);

                doc.roundedRect(x, y, w, h, 20).fillAndStroke(colors.white, colors.border);

                doc.roundedRect(x + 16, y + 34, 44, 6, 3).fill(colors.mint);

                const stars = Array.from({ length: 5 }, (_, i) => (i < starsFilled ? '★' : '☆')).join(' ');
                doc
                    .fillColor(colors.primary)
                    .font('Helvetica-Bold')
                    .fontSize(18)
                    .text(stars, x + 16, y + 50);

                const row = (label, value, yy) => {
                    doc.fillColor(colors.subtext).font('Helvetica-Bold').fontSize(10).text(label, x + 16, yy);
                    doc.fillColor(colors.text).font('Helvetica-Bold').fontSize(10).text(value, x + w - 120, yy, {
                        width: 100,
                        align: 'right',
                    });
                };

                row(t.reviews, String(data.feedback?.totalReviews ?? 0), y + 80);
                row(t.average, rating.toFixed(1), y + 99);
                row(t.highest, `${data.feedback?.highestScore ?? 0}/5`, y + 118);

                doc
                    .roundedRect(x + 205, y + 50, w - 225, 75, 14)
                    .fill(colors.softMint);

                doc
                    .fillColor(colors.primary)
                    .font('Helvetica-Bold')
                    .fontSize(10)
                    .text(t.latestReview, x + 220, y + 62);

                doc
                    .fillColor(colors.text)
                    .font('Helvetica')
                    .fontSize(9.5)
                    .text(safeText(data.feedback?.latestReview, t.noReviews), x + 220, y + 80, {
                        width: w - 255,
                        height: 35,
                        ellipsis: true,
                    });

                doc
                    .fillColor(colors.dark)
                    .font('Helvetica-Bold')
                    .fontSize(24)
                    .text(rating.toFixed(1), x + w - 80, y + 14, { width: 55, align: 'right' });

                doc.y = y + h + 16;
            };

            const drawHealthSnapshot = () => {
                ensureSpace(160);

                drawSectionHeader(t.healthSnapshot, t.healthSubtitle);

                const items = [
                    [t.diabetes, `${data.healthSnapshot?.diabetes ?? 0}%`],
                    [t.allergies, `${data.healthSnapshot?.allergies ?? 0}%`],
                    [t.lowSodium, `${data.healthSnapshot?.lowSodium ?? 0}%`],
                    [t.highProtein, `${data.healthSnapshot?.highProtein ?? 0}%`],
                ];

                const gap = 12;
                const w = (contentWidth - gap) / 2;
                const h = 58;
                const startY = doc.y;

                items.forEach((item, i) => {
                    const row = Math.floor(i / 2);
                    const col = i % 2;
                    const x = contentLeft + col * (w + gap);
                    const y = startY + row * (h + gap);

                    doc.roundedRect(x, y, w, h, 18).fillAndStroke(colors.softMint, colors.mint);

                    doc
                        .fillColor(colors.primary)
                        .font('Helvetica-Bold')
                        .fontSize(11)
                        .text(item[0], x + 14, y + 13);

                    doc
                        .fillColor(colors.text)
                        .font('Helvetica-Bold')
                        .fontSize(18)
                        .text(item[1], x + 14, y + 31);
                });

                doc.y = startY + h * 2 + gap + 16;
            };

            const drawTopMeals = () => {
                ensureSpace(145);

                drawSectionHeader(t.topMeals, t.topMealsSubtitle);

                const items = data.topMeals || [];

                if (items.length === 0) {
                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica-Bold')
                        .fontSize(10)
                        .text(t.noMeals, contentLeft, doc.y);
                    doc.moveDown(1);
                    return;
                }

                items.forEach((meal, i) => {
                    const y = doc.y;

                    doc.roundedRect(contentLeft, y, contentWidth, 48, 16).fillAndStroke(colors.card, colors.border);

                    doc.roundedRect(contentLeft + 12, y + 9, 30, 30, 10).fill(colors.softMint);

                    doc
                        .fillColor(colors.primary)
                        .font('Helvetica-Bold')
                        .fontSize(13)
                        .text('🍽', contentLeft + 19, y + 16);

                    const mealName = isArabic
                        ? safeText(meal.name_ar || meal.name || meal.name_en)
                        : safeText(meal.name_en || meal.name || meal.name_ar);

                    doc
                        .fillColor(colors.text)
                        .font('Helvetica-Bold')
                        .fontSize(11)
                        .text(`${i + 1}. ${mealName}`, contentLeft + 54, y + 15, {
                            width: contentWidth - 170,
                        });

                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica-Bold')
                        .fontSize(10)
                        .text(`${meal.orders ?? 0} ${t.orders}`, contentLeft + contentWidth - 115, y + 17, {
                            width: 95,
                            align: 'right',
                        });

                    doc.y = y + 58;
                });
            };

            drawPageHeader();
            drawHeroCard();
            drawAiInsights();
            drawKpiCards();
            drawBarChart(data.demandTrend || []);
            drawFeedbackCard();
            drawHealthSnapshot();
            drawTopMeals();

            doc.end();
        } catch (error) {
            console.error('Generate provider dashboard PDF error:', error);
            return res.status(500).json({
                message: 'Failed to generate PDF report',
            });
        }
    }
}

module.exports = new ReportController();