import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_notifications_page.dart';

class ProviderDashboardPage extends StatefulWidget {
  static const String routeName = '/provider-dashboard';
  const ProviderDashboardPage({super.key});

  @override
  State<ProviderDashboardPage> createState() => _ProviderDashboardPageState();
}

class _ProviderDashboardPageState extends State<ProviderDashboardPage> {
  static const Color bg = Color(0xFFF1F7F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color green2 = Color(0xFF1E8A72);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE8F7F1);
  static const Color gold = Color(0xFFF0E0C0);

  int _navIndex = 2;

  void _openNotificationsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProviderNotificationsPage()),
    );
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    }
  }

  void _handleBottomNavTap(int i) {
    if (i == _navIndex) return;

    HapticFeedback.selectionClick();
    setState(() => _navIndex = i);

    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    } else if (i == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IncomingMealRequestsPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacementNamed(context, '/providerProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _DashboardMainAppBar(
        onBack: _handleBack,
        onTapNotifications: _openNotificationsPage,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _DashboardPageHeader(),
              const SizedBox(height: 14),

              const _HeroSummaryCard(totalOrders: 140, wastePercent: 7.8),

              const SizedBox(height: 14),

              Row(
                children: const [
                  Expanded(
                    child: _KpiCard(
                      title: "Waste Rate",
                      value: "7.8%",
                      sub: "Lower than yesterday",
                      icon: Icons.delete_outline_rounded,
                      tone: KpiTone.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      title: "Diet Match",
                      value: "86%",
                      sub: "Matched with profiles",
                      icon: Icons.health_and_safety_outlined,
                      tone: KpiTone.mint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _KpiCard(
                      title: "Meal Acceptance",
                      value: "91%",
                      sub: "Accepted requests",
                      icon: Icons.check_circle_outline_rounded,
                      tone: KpiTone.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      title: "Campaigns",
                      value: "6",
                      sub: "Active campaigns",
                      icon: Icons.campaign_outlined,
                      tone: KpiTone.mint,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _AnalyticsCard(
                title: "Waste Trend",
                subtitle: "Daily meal waste over the last 7 days",
                child: const _WasteTrendChart(),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 220,
                child: Row(
                  children: const [
                    Expanded(
                      child: _FeedbackCard(
                        rating: 4.2,
                        starsFilled: 4,
                        feedbackLines: 4,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _AISuggestionsCard(
                        headline: "AI Suggestions",
                        suggestions: [
                          "Reduce rice quantity in lunch meals.",
                          "Increase diabetic-friendly meals tomorrow.",
                          "Shrimp meals are trending in Campaign #21.",
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _AnalyticsCard(
                title: "Pilgrim Health Snapshot",
                subtitle: "Common dietary and health indicators",
                child: const _HealthInsightsGrid(),
              ),

              const SizedBox(height: 14),

              _AnalyticsCard(
                title: "Top Requested Meals",
                subtitle: "Most ordered meals today",
                child: const _TopMealsList(),
              ),

              const SizedBox(height: 18),

              _GenerateReportButton(
                onTap: () => HapticFeedback.selectionClick(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

/// =======================
/// APP BAR
/// =======================
class _DashboardMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onTapNotifications;

  const _DashboardMainAppBar({
    required this.onBack,
    required this.onTapNotifications,
  });

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.6,
      shadowColor: Colors.black.withOpacity(0.08),
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 4,
      title: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            "NUSUQ",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onTapNotifications,
          icon: const Icon(
            Icons.notifications,
            color: Colors.black87,
            size: 20,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

/// =======================
/// PAGE HEADER
/// =======================
class _DashboardPageHeader extends StatelessWidget {
  const _DashboardPageHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Performance & Reports",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
        ),
        Text(
          "Updated 5 min ago",
          style: TextStyle(
            fontSize: 11.8,
            fontWeight: FontWeight.w800,
            color: Colors.black.withOpacity(0.52),
          ),
        ),
      ],
    );
  }
}

/// =======================
/// Hero summary
/// =======================
class _HeroSummaryCard extends StatelessWidget {
  final int totalOrders;
  final double wastePercent;

  const _HeroSummaryCard({
    required this.totalOrders,
    required this.wastePercent,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primary, primaryMid],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 14),
            color: primary.withOpacity(0.24),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mint.withOpacity(0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Dashboard Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: gold.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: Text(
                      "AI Powered",
                      style: TextStyle(
                        color: gold.withOpacity(0.95),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      title: "Today's Orders",
                      value: "$totalOrders",
                      dotColor: mint,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _HeroMetric(
                      title: "Waste",
                      value: "${wastePercent.toStringAsFixed(1)}%",
                      dotColor: gold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _HeroProgressPill(
                label: "Waste control",
                percent: (100 - wastePercent).clamp(0, 100).toDouble(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String title;
  final String value;
  final Color dotColor;

  const _HeroMetric({
    required this.title,
    required this.value,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroProgressPill extends StatelessWidget {
  final String label;
  final double percent;

  const _HeroProgressPill({required this.label, required this.percent});

  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    final p = (percent / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 10,
                    child: Stack(
                      children: [
                        Container(color: Colors.white.withOpacity(0.10)),
                        FractionallySizedBox(
                          widthFactor: p,
                          child: Container(color: mint.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "${percent.toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// KPI cards
/// =======================
enum KpiTone { green, mint }

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final IconData icon;
  final KpiTone tone;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.sub,
    required this.icon,
    required this.tone,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color green2 = Color(0xFF1E8A72);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE8F7F1);

  @override
  Widget build(BuildContext context) {
    final iconBg = tone == KpiTone.green ? mint.withOpacity(0.30) : softMint;
    final iconColor = tone == KpiTone.green ? primary : green2;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 10),
            color: primary.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.2,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withOpacity(0.72),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11.3,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// Analytics wrapper
/// =======================
class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _AnalyticsCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 10),
            color: primary.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black.withOpacity(0.52),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// =======================
/// Waste trend chart
/// =======================
class _WasteTrendChart extends StatelessWidget {
  const _WasteTrendChart();

  @override
  Widget build(BuildContext context) {
    final values = [14, 11, 10, 8, 9, 7, 6];
    final labels = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
    final maxV = values.reduce((a, b) => a > b ? a : b).toDouble();

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final h = (values[i] / maxV) * 86.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${values[i]}",
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.55),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: h.clamp(10.0, 86.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E8A72),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// =======================
/// Feedback card
/// =======================
class _FeedbackCard extends StatelessWidget {
  final double rating;
  final int starsFilled;
  final int feedbackLines;

  const _FeedbackCard({
    required this.rating,
    required this.starsFilled,
    required this.feedbackLines,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 10),
            color: primary.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Feedback", style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              final filled = i < starsFilled;
              return Icon(
                filled ? Icons.star_rounded : Icons.star_border_rounded,
                size: 20,
                color: filled ? primary : Colors.black.withOpacity(0.30),
              );
            }),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            feedbackLines,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                height: 5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: mint,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Average score",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.52),
                ),
              ),
              const Spacer(),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// =======================
/// AI card
/// =======================
class _AISuggestionsCard extends StatelessWidget {
  final String headline;
  final List<String> suggestions;

  const _AISuggestionsCard({required this.headline, required this.suggestions});

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE8F7F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF6FCF9)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 10),
            color: primary.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headline, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Container(
            width: 44,
            height: 6,
            decoration: BoxDecoration(
              color: mint.withOpacity(0.75),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: softMint,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: mint.withOpacity(0.55)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: primary.withOpacity(0.82),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          suggestions[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.70),
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// Health insights
/// =======================
class _HealthInsightsGrid extends StatelessWidget {
  const _HealthInsightsGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _HealthInsightCard(
                title: "Diabetes",
                value: "18%",
                icon: Icons.bloodtype_outlined,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _HealthInsightCard(
                title: "Allergies",
                value: "12%",
                icon: Icons.warning_amber_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _HealthInsightCard(
                title: "Low Sodium",
                value: "9%",
                icon: Icons.health_and_safety_outlined,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _HealthInsightCard(
                title: "High Protein",
                value: "22%",
                icon: Icons.fitness_center_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HealthInsightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _HealthInsightCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F7F1);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: softMint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mint.withOpacity(0.60)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primary.withOpacity(0.85)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: primary.withOpacity(0.92),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// Top meals
/// =======================
class _TopMealsList extends StatelessWidget {
  const _TopMealsList();

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    final items = const [
      ("Grilled Chicken + Rice", "320 orders"),
      ("Shrimp Meal", "270 orders"),
      ("Vegetarian Bowl", "190 orders"),
    ];

    return Column(
      children: List.generate(items.length, (i) {
        final (name, count) = items[i];
        return Padding(
          padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FCFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: mint.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: mint.withOpacity(0.55)),
                  ),
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    color: primary.withOpacity(0.80),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  count,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// =======================
/// Button
/// =======================
class _GenerateReportButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GenerateReportButton({required this.onTap});

  static const Color primaryDark = Color(0xFF052720);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style:
            ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                Colors.white.withOpacity(0.08),
              ),
            ),
        child: const Text(
          "GENERATE REPORT",
          style: TextStyle(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
