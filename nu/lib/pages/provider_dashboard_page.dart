import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

import '../l10n/app_localizations.dart';
import '../widgets/provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_notifications_page.dart';
import '../models/provider_dashboard_report.dart';
import '../services/report_service.dart';
import '../services/ai_dashboard_service.dart';
import '../session/user_session.dart';

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

  int _navIndex = 2;

  ProviderDashboardReport? _report;
  bool _isLoading = true;
  String? _error;

  final ReportService _reportService = ReportService(
    baseUrl: kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000',
  );

  final AiDashboardService _aiDashboardService = AiDashboardService();

  String? _aiAnalysis;
  bool _isAiLoading = false;

  String? _providerId;
  bool _didInitDashboard = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initDashboard();
      }
    });
  }

  Future<void> _initDashboard() async {
    try {
      final providerId = UserSession.userId;

      if (providerId == null || providerId.isEmpty) {
        throw Exception('Provider ID not found in session');
      }

      _providerId = providerId;

      await _loadDashboard();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDashboard() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final providerId = _providerId;

      if (providerId == null || providerId.isEmpty) {
        throw Exception('Provider ID is missing');
      }

      final language = Localizations.localeOf(context).languageCode;

      final data = await _reportService.getProviderDashboard(
        providerId,
        language,
      );

      if (!mounted) return;

      setState(() {
        _report = data;
        _isLoading = false;
      });

      // نخلي تحليل AI يشتغل بالخلفية بدون ما يعلّق الصفحة
      _loadAiAnalysis();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAiAnalysis() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final providerId = _providerId;

      if (providerId == null || providerId.isEmpty) return;

      setState(() {
        _isAiLoading = true;
        _aiAnalysis = null;
      });

      final result = await _aiDashboardService
          .getProviderAnalysis(
            providerID: providerId,
            language: Localizations.localeOf(context).languageCode,
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('AI analysis timed out');
            },
          );

      if (!mounted) return;

      setState(() {
        _aiAnalysis = result;
        _isAiLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _aiAnalysis = l10n.aiAnalysisUnavailable;
        _isAiLoading = false;
      });
    }
  }

  Future<void> _openPdfReport() async {
    final l10n = AppLocalizations.of(context)!;

    final providerId = _providerId;

    if (providerId == null || providerId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.providerIdIsMissing)));
      return;
    }

    final language = Localizations.localeOf(context).languageCode;

    final pdfUrl = _reportService.getProviderDashboardPdfUrl(
      providerId,
      language,
    );

    final uri = Uri.parse(pdfUrl);

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenPdfReport)));
    }
  }

  void _openNotificationsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProviderNotificationsPage()),
    );
  }

  void _handleBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
    );
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

  Widget _buildContent() {
    final l10n = AppLocalizations.of(context)!;
    final report = _report!;

    return RefreshIndicator(
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DashboardPageHeader(updatedAt: report.updatedAt),
            const SizedBox(height: 14),
            _HeroSummaryCard(
              totalOrders: report.todayOrders,
              campaignsCount: report.campaigns,
              acceptancePercent: report.mealAcceptance.toDouble(),
            ),
            const SizedBox(height: 14),
            _AiDashboardSection(
              analysis: _aiAnalysis,
              isLoading: _isAiLoading,
              onRefresh: _loadAiAnalysis,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: l10n.mealAcceptance,
                    value: "${report.mealAcceptance}%",
                    sub: l10n.acceptedRequests,
                    icon: Icons.check_circle_outline_rounded,
                    tone: KpiTone.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    title: l10n.feedbackAverage,
                    value: report.averageScore.toStringAsFixed(1),
                    sub: l10n.averageRating,
                    icon: Icons.star_border_rounded,
                    tone: KpiTone.mint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _AnalyticsCard(
              title: l10n.orderTrend,
              subtitle: l10n.dailyOrdersLast7Days,
              child: _OrderTrendChart(data: report.orderTrend),
            ),
            const SizedBox(height: 14),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _FeedbackCard(
                      rating: report.averageScore,
                      starsFilled: report.starsFilled,
                      totalReviews: report.totalReviews,
                      highestScore: report.highestScore,
                      latestReview: report.latestReview,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _AnalyticsCard(
              title: l10n.pilgrimHealthSnapshot,
              subtitle: l10n.commonDietaryHealthIndicators,
              child: _HealthInsightsGrid(
                diabetes: report.healthSnapshot['diabetes'] ?? 0,
                allergies: report.healthSnapshot['allergies'] ?? 0,
                lowSodium: report.healthSnapshot['lowSodium'] ?? 0,
                highProtein: report.healthSnapshot['highProtein'] ?? 0,
              ),
            ),
            const SizedBox(height: 14),
            _AnalyticsCard(
              title: l10n.topRequestedMeals,
              subtitle: l10n.mostOrderedMealsToday,
              child: _TopMealsList(items: report.topMeals),
            ),
            const SizedBox(height: 18),
            _GenerateReportButton(
              onTap: () async {
                HapticFeedback.selectionClick();
                await _openPdfReport();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bg,
      appBar: _DashboardMainAppBar(
        onBack: _handleBack,
        onTapNotifications: _openNotificationsPage,
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: _loadDashboard,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              )
            : _buildContent(),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

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

class _DashboardPageHeader extends StatelessWidget {
  final String updatedAt;
  const _DashboardPageHeader({required this.updatedAt});

  String _formatUpdatedAt(String value, AppLocalizations l10n) {
    if (value.isEmpty) return l10n.updatedRecently;
    try {
      final dt = DateTime.parse(value).toLocal();
      return "${l10n.updated} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return l10n.updatedRecently;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.performanceAndReports,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
        ),
        Text(
          _formatUpdatedAt(updatedAt, l10n),
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

class _HeroSummaryCard extends StatelessWidget {
  final int totalOrders;
  final int campaignsCount;
  final double acceptancePercent;

  const _HeroSummaryCard({
    required this.totalOrders,
    required this.campaignsCount,
    required this.acceptancePercent,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  Text(
                    l10n.dashboardOverview,
                    style: const TextStyle(
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
                      l10n.liveData,
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
                      title: l10n.todaysOrders,
                      value: "$totalOrders",
                      dotColor: mint,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _HeroMetric(
                      title: l10n.campaigns,
                      value: "$campaignsCount",
                      dotColor: gold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _HeroProgressPill(
                label: l10n.acceptanceRate,
                percent: acceptancePercent,
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

class _OrderTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const _OrderTrendChart({required this.data});

  String _localizedDay(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;

    switch (label.toLowerCase().trim()) {
      case 'mon':
      case 'monday':
        return l10n.mondayShort;
      case 'tue':
      case 'tuesday':
        return l10n.tuesdayShort;
      case 'wed':
      case 'wednesday':
        return l10n.wednesdayShort;
      case 'thu':
      case 'thursday':
        return l10n.thursdayShort;
      case 'fri':
      case 'friday':
        return l10n.fridayShort;
      case 'sat':
      case 'saturday':
        return l10n.saturdayShort;
      case 'sun':
      case 'sunday':
        return l10n.sundayShort;
      default:
        return label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final values = data
        .map((e) => (e['value'] as num?)?.toDouble() ?? 0.0)
        .toList();

    final labels = data.map((e) => (e['label'] ?? '').toString()).toList();

    final maxV = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final h = maxV == 0 ? 10.0 : (values[i] / maxV) * 86.0;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    values[i].toInt().toString(),
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
                      _localizedDay(context, labels[i]),
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

class _FeedbackCard extends StatelessWidget {
  final double rating;
  final int starsFilled;
  final int totalReviews;
  final int highestScore;
  final String latestReview;

  const _FeedbackCard({
    required this.rating,
    required this.starsFilled,
    required this.totalReviews,
    required this.highestScore,
    required this.latestReview,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: double.infinity,
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
          Text(
            l10n.feedback,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 6,
            decoration: BoxDecoration(
              color: mint.withOpacity(0.75),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
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
          _FeedbackInfoRow(label: l10n.reviews, value: "$totalReviews"),
          const SizedBox(height: 6),
          _FeedbackInfoRow(
            label: l10n.average,
            value: rating.toStringAsFixed(1),
          ),
          const SizedBox(height: 6),
          _FeedbackInfoRow(label: l10n.highest, value: "$highestScore/5"),
          const SizedBox(height: 10),
          Text(
            l10n.latestReview,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: Colors.black.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: mint.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mint.withOpacity(0.45)),
            ),
            child: Text(
              latestReview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.8,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.72),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                l10n.averageScore,
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

class _FeedbackInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _FeedbackInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.8,
            fontWeight: FontWeight.w700,
            color: Colors.black.withOpacity(0.56),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}


class _HealthInsightsGrid extends StatelessWidget {
  final int diabetes;
  final int allergies;
  final int lowSodium;
  final int highProtein;

  const _HealthInsightsGrid({
    required this.diabetes,
    required this.allergies,
    required this.lowSodium,
    required this.highProtein,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _HealthInsightCard(
                title: l10n.diabetes,
                value: "$diabetes%",
                icon: Icons.bloodtype_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HealthInsightCard(
                title: l10n.allergies,
                value: "$allergies%",
                icon: Icons.warning_amber_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _HealthInsightCard(
                title: l10n.lowSodium,
                value: "$lowSodium%",
                icon: Icons.health_and_safety_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HealthInsightCard(
                title: l10n.highProtein,
                value: "$highProtein%",
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

class _TopMealsList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _TopMealsList({required this.items});

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          l10n.noMealRequestsYet,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black.withOpacity(0.55),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final languageCode = Localizations.localeOf(context).languageCode;
        final isArabic = languageCode.toLowerCase().startsWith('ar');

        final name = isArabic
            ? ((item['name_ar'] ?? item['name'] ?? item['name_en'] ?? '')
                  .toString())
            : ((item['name_en'] ?? item['name'] ?? item['name_ar'] ?? '')
                  .toString());

        final count = (item['orders'] ?? 0).toString();

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
                  "$count ${l10n.orders}",
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

class _GenerateReportButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GenerateReportButton({required this.onTap});

  static const Color primaryDark = Color(0xFF052720);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        child: Text(
          l10n.generateReport.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _AiDashboardSection extends StatelessWidget {
  final String? analysis;
  final bool isLoading;
  final VoidCallback onRefresh;

  const _AiDashboardSection({
    required this.analysis,
    required this.isLoading,
    required this.onRefresh,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parsed = _parseAnalysis(analysis ?? '', l10n);

    return Container(
      width: double.infinity,
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
            color: primary.withOpacity(0.22),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.14)),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: gold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aiDashboardInsights,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.smartAnalysisBasedOnOrders,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: isLoading ? null : onRefresh,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isLoading)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.generatingAiInsights,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            _AiInsightCard(
              title: l10n.aiSummary,
              icon: Icons.analytics_rounded,
              content: parsed.summary,
            ),
            const SizedBox(height: 10),
            _AiInsightCard(
              title: l10n.feedbackRiskAnalysis,
              icon: Icons.warning_amber_rounded,
              content: parsed.risks,
            ),
            const SizedBox(height: 10),
            _AiInsightCard(
              title: l10n.smartRecommendations,
              icon: Icons.tips_and_updates_rounded,
              content: parsed.recommendations,
              highlighted: true,
            ),
          ],
        ],
      ),
    );
  }

  _ParsedAiAnalysis _parseAnalysis(String value, AppLocalizations l10n) {
    final cleaned = _cleanText(value);

    if (cleaned.trim().isEmpty) {
      return _ParsedAiAnalysis(
        summary: l10n.noAiSummaryAvailableYet,
        risks: l10n.noFeedbackRiskAnalysisAvailableYet,
        recommendations: l10n.noSmartRecommendationsAvailableYet,
      );
    }

    final summary = _extractSection(
      cleaned,
      ['Overall Summary', 'AI Summary', 'Summary'],
      [
        'Most Requested Meals',
        'Problems or Risks',
        'Feedback Analysis',
        'Recommendations',
      ],
    );

    final meals = _extractSection(
      cleaned,
      ['Most Requested Meals'],
      ['Problems or Risks', 'Feedback Analysis', 'Recommendations'],
    );

    final risks = _extractSection(
      cleaned,
      ['Problems or Risks', 'Feedback Analysis', 'Risk Analysis'],
      ['Recommendations', 'Smart Recommendations'],
    );

    final recommendations = _extractSection(cleaned, [
      'Recommendations',
      'Smart Recommendations',
    ], []);

    return _ParsedAiAnalysis(
      summary: _joinNonEmpty([
        summary,
        if (meals.isNotEmpty) '${l10n.mostRequestedMeals}:\n$meals',
      ], fallback: l10n.noAiSummaryAvailableYet),
      risks: risks.isEmpty ? l10n.noFeedbackRiskAnalysisAvailableYet : risks,
      recommendations: recommendations.isEmpty
          ? l10n.noSmartRecommendationsAvailableYet
          : recommendations,
    );
  }

  String _cleanText(String value) {
    return value
        .replaceAll('###', '')
        .replaceAll('##', '')
        .replaceAll('#', '')
        .replaceAll('**', '')
        .replaceAll('*', '')
        .trim();
  }

  String _joinNonEmpty(List<String> parts, {required String fallback}) {
    final filtered = parts.map((e) => e.trim()).where((e) => e.isNotEmpty);
    if (filtered.isEmpty) return fallback;
    return filtered.join('\n\n');
  }

  String _extractSection(
    String text,
    List<String> startLabels,
    List<String> endLabels,
  ) {
    final lower = text.toLowerCase();

    int startIndex = -1;
    String selectedLabel = '';

    for (final label in startLabels) {
      final index = lower.indexOf(label.toLowerCase());
      if (index != -1 && (startIndex == -1 || index < startIndex)) {
        startIndex = index;
        selectedLabel = label;
      }
    }

    if (startIndex == -1) return '';

    final contentStart = startIndex + selectedLabel.length;
    int endIndex = text.length;

    for (final label in endLabels) {
      final index = lower.indexOf(label.toLowerCase(), contentStart);
      if (index != -1 && index < endIndex) {
        endIndex = index;
      }
    }

    return text
        .substring(contentStart, endIndex)
        .replaceFirst(RegExp(r'^\s*:\s*'), '')
        .trim();
  }
}

class _AiInsightCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;
  final bool highlighted;

  const _AiInsightCard({
    required this.title,
    required this.icon,
    required this.content,
    this.highlighted = false,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE8F7F1);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: highlighted ? gold.withOpacity(0.96) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlighted ? gold.withOpacity(0.9) : mint.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: highlighted ? Colors.white.withOpacity(0.70) : softMint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 12.3,
                    height: 1.42,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.76),
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

class _ParsedAiAnalysis {
  final String summary;
  final String risks;
  final String recommendations;

  const _ParsedAiAnalysis({
    required this.summary,
    required this.risks,
    required this.recommendations,
  });
}
