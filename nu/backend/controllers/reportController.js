const PDFDocument = require('pdfkit');
const reportService = require('../services/ReportService');

class ReportController {
    async getProviderDashboard(req, res) {
        try {
            const { providerID } = req.params;

            if (!providerID) {
                return res.status(400).json({
                    message: 'providerID is required',
                });
            }

            const data = await reportService.getProviderDashboard(providerID);

            return res.status(200).json(data);
        } catch (error) {
            console.error('Get provider dashboard error:', error);
            return res.status(500).json({
                message: 'Failed to load dashboard report',
            });
        }
    }

    async generateProviderDashboardPdf(req, res) {
        try {
            const { providerID } = req.params;

            if (!providerID) {
                return res.status(400).json({
                    message: 'providerID is required',
                });
            }

            const data = await reportService.getProviderDashboard(providerID);

            const doc = new PDFDocument({
                margin: 40,
                size: 'A4',
            });

            const fileName = `provider-report-${providerID}.pdf`;

            res.setHeader('Content-Type', 'application/pdf');
            res.setHeader('Content-Disposition', `inline; filename="${fileName}"`);

            doc.pipe(res);

            const colors = {
                dark: '#052720',
                primary: '#0B4A40',
                green: '#1E8A72',
                mint: '#A8E7CF',
                softMint: '#E8F7F1',
                gold: '#F0E0C0',
                text: '#1F2937',
                subtext: '#6B7280',
                border: '#D9E6E1',
                white: '#FFFFFF',
                card: '#F8FCFA',
            };

            const safeText = (value, fallback = '-') => {
                if (value === null || value === undefined) return fallback;
                const str = String(value).trim();
                return str === '' ? fallback : str;
            };

            const pageWidth = doc.page.width;
            const contentLeft = 40;
            const contentRight = pageWidth - 40;
            const contentWidth = contentRight - contentLeft;

            const drawSectionTitle = (title) => {
                doc.moveDown(0.8);
                doc
                    .fillColor(colors.primary)
                    .fontSize(16)
                    .font('Helvetica-Bold')
                    .text(title, contentLeft, doc.y);
                doc.moveDown(0.35);
            };

            const drawDivider = () => {
                const y = doc.y;
                doc
                    .moveTo(contentLeft, y)
                    .lineTo(contentRight, y)
                    .lineWidth(1)
                    .strokeColor(colors.border)
                    .stroke();
                doc.moveDown(0.8);
            };

            const drawInfoLine = (label, value) => {
                doc
                    .fillColor(colors.subtext)
                    .font('Helvetica-Bold')
                    .fontSize(10)
                    .text(label, contentLeft, doc.y, { continued: true });
                doc
                    .fillColor(colors.text)
                    .font('Helvetica')
                    .fontSize(10)
                    .text(` ${safeText(value)}`);
            };

            const drawMetricCard = (x, y, w, h, title, value, subtitle) => {
                doc
                    .roundedRect(x, y, w, h, 14)
                    .fillAndStroke(colors.card, colors.border);

                doc
                    .fillColor(colors.subtext)
                    .font('Helvetica-Bold')
                    .fontSize(10)
                    .text(title, x + 14, y + 12, { width: w - 28 });

                doc
                    .fillColor(colors.dark)
                    .font('Helvetica-Bold')
                    .fontSize(22)
                    .text(String(value), x + 14, y + 30, { width: w - 28 });

                doc
                    .fillColor(colors.subtext)
                    .font('Helvetica')
                    .fontSize(9)
                    .text(subtitle, x + 14, y + 58, { width: w - 28 });
            };

            const drawBarChart = (items) => {
                const chartX = contentLeft + 10;
                const chartY = doc.y + 8;
                const chartW = contentWidth - 20;
                const chartH = 170;

                doc
                    .roundedRect(contentLeft, doc.y, contentWidth, chartH + 36, 18)
                    .fillAndStroke(colors.white, colors.border);

                const values = items.map((e) => Number(e.value || 0));
                const maxValue = Math.max(...values, 1);

                const innerX = chartX + 10;
                const innerY = chartY + 12;
                const innerW = chartW - 20;
                const innerH = 110;
                const gap = 12;
                const barW = (innerW - gap * (items.length - 1)) / items.length;

                doc
                    .moveTo(innerX, innerY + innerH)
                    .lineTo(innerX + innerW, innerY + innerH)
                    .lineWidth(1)
                    .strokeColor(colors.border)
                    .stroke();

                items.forEach((item, index) => {
                    const value = Number(item.value || 0);
                    const label = safeText(item.label, '-');
                    const barH = maxValue === 0 ? 8 : Math.max(8, (value / maxValue) * 88);
                    const x = innerX + index * (barW + gap);
                    const y = innerY + innerH - barH;

                    doc
                        .roundedRect(x, y, barW, barH, 8)
                        .fill(colors.green);

                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica-Bold')
                        .fontSize(9)
                        .text(String(value), x, y - 14, {
                            width: barW,
                            align: 'center',
                        });

                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica')
                        .fontSize(9)
                        .text(label, x, innerY + innerH + 8, {
                            width: barW,
                            align: 'center',
                        });
                });

                doc.y = chartY + chartH + 10;
            };

            const drawBulletList = (items, emptyText) => {
                if (!items || items.length === 0) {
                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica')
                        .fontSize(10)
                        .text(emptyText, contentLeft, doc.y);
                    return;
                }

                items.forEach((item, index) => {
                    doc
                        .fillColor(colors.green)
                        .font('Helvetica-Bold')
                        .fontSize(11)
                        .text(`${index + 1}.`, contentLeft, doc.y, { continued: true });

                    doc
                        .fillColor(colors.text)
                        .font('Helvetica')
                        .fontSize(10.5)
                        .text(` ${safeText(item)}`, {
                            width: contentWidth - 20,
                        });

                    doc.moveDown(0.15);
                });
            };

            const drawTopMeals = (items) => {
                if (!items || items.length === 0) {
                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica')
                        .fontSize(10)
                        .text('No meal requests yet.', contentLeft, doc.y);
                    return;
                }

                items.forEach((meal, index) => {
                    doc
                        .roundedRect(contentLeft, doc.y, contentWidth, 28, 10)
                        .fillAndStroke(colors.card, colors.border);

                    doc
                        .fillColor(colors.text)
                        .font('Helvetica-Bold')
                        .fontSize(10.5)
                        .text(`${index + 1}. ${safeText(meal.name)}`, contentLeft + 12, doc.y + 8, {
                            width: contentWidth - 120,
                        });

                    doc
                        .fillColor(colors.subtext)
                        .font('Helvetica-Bold')
                        .fontSize(10)
                        .text(`${meal.orders ?? 0} orders`, contentLeft, doc.y - 12, {
                            width: contentWidth - 12,
                            align: 'right',
                        });

                    doc.moveDown(1.2);
                });
            };

            // Header
            doc
                .roundedRect(contentLeft, 35, contentWidth, 95, 24)
                .fill(colors.softMint);

            doc
                .fillColor(colors.dark)
                .font('Helvetica-Bold')
                .fontSize(24)
                .text('NUSUQ Provider Performance Report', contentLeft, 58, {
                    width: contentWidth,
                    align: 'center',
                });

            doc
                .fillColor(colors.subtext)
                .font('Helvetica')
                .fontSize(10.5)
                .text(`Provider ID: ${providerID}`, contentLeft, 95, {
                    width: contentWidth,
                    align: 'center',
                })
                .text(`Generated at: ${new Date(data.updatedAt).toLocaleString()}`, contentLeft, 111, {
                    width: contentWidth,
                    align: 'center',
                });

            doc.y = 150;

            // Overview cards
            drawSectionTitle('Overview');

            const cardY = doc.y;
            const gap = 12;
            const cardW = (contentWidth - gap) / 2;
            const cardH = 82;

            drawMetricCard(
                contentLeft,
                cardY,
                cardW,
                cardH,
                "Today's Orders",
                data.overview?.todayOrders ?? 0,
                'Orders placed today'
            );

            drawMetricCard(
                contentLeft + cardW + gap,
                cardY,
                cardW,
                cardH,
                'Campaigns',
                data.kpis?.campaigns?.value ?? 0,
                'Total linked campaigns'
            );

            doc.y = cardY + cardH + 18;

            drawInfoLine('Acceptance Rate:', `${data.kpis?.mealAcceptance?.value ?? 0}%`);
            drawInfoLine('Average Rating:', `${data.feedback?.averageScore ?? 0}`);
            drawInfoLine('Total Reviews:', `${data.feedback?.totalReviews ?? 0}`);
            drawInfoLine('Highest Rating:', `${data.feedback?.highestScore ?? 0}/5`);
            drawInfoLine('Latest Review:', safeText(data.feedback?.latestReview, 'No reviews yet'));

            drawDivider();

            // Chart
            drawSectionTitle('Order Trend (Last 7 Days)');
            drawBarChart(data.demandTrend || []);
            drawDivider();

            // Health snapshot
            drawSectionTitle('Health Snapshot');
            drawInfoLine('Diabetes:', `${data.healthSnapshot?.diabetes ?? 0}%`);
            drawInfoLine('Allergies:', `${data.healthSnapshot?.allergies ?? 0}%`);
            drawInfoLine('Low Sodium:', `${data.healthSnapshot?.lowSodium ?? 0}%`);
            drawInfoLine('High Protein:', `${data.healthSnapshot?.highProtein ?? 0}%`);
            drawDivider();

            // Top meals
            drawSectionTitle('Top Requested Meals');
            drawTopMeals(data.topMeals || []);
            drawDivider();

            // Suggestions
            drawSectionTitle('Smart Suggestions');
            drawBulletList(data.aiSuggestions || [], 'No suggestions available.');

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