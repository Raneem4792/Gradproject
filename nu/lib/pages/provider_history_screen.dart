import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/meal_order.dart';
import '../models/rate.dart';
import '../services/meal_service.dart';
import '../services/rate_service.dart';
import '../session/user_session.dart';
import '../widgets/provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_notifications_page.dart';

class ProviderHistoryScreen extends StatefulWidget {
  const ProviderHistoryScreen({super.key});
  static const routeName = '/provider-history';

  @override
  State<ProviderHistoryScreen> createState() => _ProviderHistoryScreenState();
}

class _ProviderHistoryScreenState extends State<ProviderHistoryScreen> {
  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  final MealService _mealService = MealService();
  final RateService _rateService = RateService();

  bool _isLoading = true;
  String? _error;

  List<MealOrder> _allOrders = [];
  List<MealOrder> _filteredOrders = [];
  List<Map<String, dynamic>> _campaigns = [];

  DateTime? selectedDateValue;
  String? selectedCampaignId;
  String? selectedCampaignLabel;
  String? selectedMealTypeValue;
  String? selectedStatusValue;

  int _navIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({String? campaignID}) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final providerID = UserSession.userId ?? '';
      if (providerID.isEmpty) {
        throw Exception('Provider ID not found in session');
      }

      final campaigns = await _mealService.getProviderCampaigns(providerID);
      final orders = await _mealService.getOrdersByProvider(
        providerID,
        campaignID: campaignID,
      );

      setState(() {
        _campaigns = campaigns;
        _allOrders = orders;
        _filteredOrders = List<MealOrder>.from(orders);
        _isLoading = false;
      });

      _applyLocalFilters();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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

  String _mealTypeLabel(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    final v = value.toLowerCase().trim();

    if (v == 'breakfast') return l10n.breakfast;
    if (v == 'lunch') return l10n.lunch;
    if (v == 'dinner') return l10n.dinner;
    if (v == 'healthy') return l10n.healthy;
    if (v == 'vegetarian') return l10n.vegetarian;
    if (v == 'high protein') return l10n.highProtein;
    if (v == 'low carb') return l10n.lowCarb;
    if (v == 'fast food') return l10n.fastFood;

    return value.isEmpty ? l10n.meal : value;
  }

  String _statusLabel(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    final v = value.toLowerCase().trim();

    if (v == 'completed') return l10n.completed;
    if (v == 'rejected') return l10n.rejected;
    if (v == 'cancelled') return l10n.cancelled;
    if (v == 'pending') return l10n.pending;
    if (v == 'accepted') return l10n.accepted;

    return value.isEmpty ? l10n.status : value;
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  void _applyLocalFilters() {
    final result = _allOrders.where((order) {
      final okDate = selectedDateValue == null
          ? true
          : order.requestDate.year == selectedDateValue!.year &&
                order.requestDate.month == selectedDateValue!.month &&
                order.requestDate.day == selectedDateValue!.day;

      final okMealType = selectedMealTypeValue == null
          ? true
          : (order.mealTypeEn.isNotEmpty ? order.mealTypeEn : order.mealType)
                    .toLowerCase() ==
                selectedMealTypeValue!.toLowerCase();

      final okStatus = selectedStatusValue == null
          ? true
          : order.status.toLowerCase() == selectedStatusValue!.toLowerCase();

      return okDate && okMealType && okStatus;
    }).toList();

    setState(() {
      _filteredOrders = result;
    });
  }

  Future<void> clearFilters() async {
    setState(() {
      selectedDateValue = null;
      selectedCampaignId = null;
      selectedCampaignLabel = null;
      selectedMealTypeValue = null;
      selectedStatusValue = null;
    });

    await _loadData();
  }

  Future<void> pickDateFilter() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateValue ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked == null) return;

    final clean = DateTime(picked.year, picked.month, picked.day);

    setState(() {
      selectedDateValue = clean;
    });

    _applyLocalFilters();
  }

  Future<void> pickCampaignFilter() async {
    final l10n = AppLocalizations.of(context)!;

    final picked = await showModalBottomSheet<Map<String, dynamic>?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.selectCampaign,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              title: Text(l10n.allCampaigns),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ..._campaigns.map(
              (c) => ListTile(
                title: Text(c['campaignName']?.toString() ?? l10n.campaign),
                subtitle: Text(c['campaignNumber']?.toString() ?? ''),
                onTap: () => Navigator.pop(ctx, c),
              ),
            ),
          ],
        ),
      ),
    );

    if (picked == null) {
      setState(() {
        selectedCampaignId = null;
        selectedCampaignLabel = null;
      });
      await _loadData();
      return;
    }

    final campaignID = picked['campaignID']?.toString();
    final campaignName = picked['campaignName']?.toString() ?? l10n.campaign;
    final campaignNumber = picked['campaignNumber']?.toString() ?? '';

    setState(() {
      selectedCampaignId = campaignID;
      selectedCampaignLabel = campaignNumber.isEmpty
          ? campaignName
          : '$campaignName • $campaignNumber';
    });

    await _loadData(campaignID: selectedCampaignId);
  }

  Future<void> pickMealTypeFilter() async {
    final l10n = AppLocalizations.of(context)!;

    final mealTypes =
        _allOrders
            .map(
              (e) =>
                  (e.mealTypeEn.isNotEmpty ? e.mealTypeEn : e.mealType).trim(),
            )
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    final picked = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.selectMealType,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              title: Text(l10n.all),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ...mealTypes.map(
              (type) => ListTile(
                title: Text(_mealTypeLabel(context, type)),
                onTap: () => Navigator.pop(ctx, type),
              ),
            ),
          ],
        ),
      ),
    );

    setState(() {
      selectedMealTypeValue = picked;
    });

    _applyLocalFilters();
  }

  Future<void> pickStatusFilter() async {
    final l10n = AppLocalizations.of(context)!;

    final statuses =
        _allOrders
            .map((e) => e.status.trim())
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    final picked = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.selectStatus,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              title: Text(l10n.all),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ...statuses.map(
              (status) => ListTile(
                title: Text(_statusLabel(context, status)),
                onTap: () => Navigator.pop(ctx, status),
              ),
            ),
          ],
        ),
      ),
    );

    setState(() {
      selectedStatusValue = picked;
    });

    _applyLocalFilters();
  }

  void _openAllReviews() {
    final reviewedOrders = _allOrders.where((e) => e.isReviewed).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProviderAllReviewsScreen(orders: reviewedOrders),
      ),
    );
  }

  Future<void> _openReviewBottomSheet(MealOrder order) async {
    if (!order.isReviewed || order.reviewRating == null) return;

    final l10n = AppLocalizations.of(context)!;

    try {
      final rate = await _rateService.getRateByOrder(order.orderID);

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        builder: (_) => _ReviewViewSheet(order: order, rate: rate),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.failedToLoadReviewDetails}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final selectedDateLabel = selectedDateValue == null
        ? l10n.date
        : _formatDate(selectedDateValue!);

    final selectedCampaignLabelText = selectedCampaignLabel ?? l10n.campaign;

    final selectedMealTypeLabel = selectedMealTypeValue == null
        ? l10n.meal
        : _mealTypeLabel(context, selectedMealTypeValue!);

    final selectedStatusLabel = selectedStatusValue == null
        ? l10n.status
        : _statusLabel(context, selectedStatusValue!);

    return Scaffold(
      backgroundColor: bg,
      appBar: _HistoryMainAppBar(
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
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HistoryHeaderCard(
                      title: l10n.orderHistory,
                      badgeText: '${_filteredOrders.length} ${l10n.orders}',
                      onAllReviews: _openAllReviews,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DropdownChip(
                            label: selectedDateLabel,
                            onTap: pickDateFilter,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DropdownChip(
                            label: selectedCampaignLabelText,
                            onTap: pickCampaignFilter,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _DropdownChip(
                            label: selectedMealTypeLabel,
                            onTap: pickMealTypeFilter,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DropdownChip(
                            label: selectedStatusLabel,
                            onTap: pickStatusFilter,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: clearFilters,
                        child: Text(
                          l10n.clear,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._filteredOrders.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _HistoryCard(
                          order: e,
                          onViewReview: e.isReviewed
                              ? () => _openReviewBottomSheet(e)
                              : null,
                        ),
                      );
                    }),
                    if (_filteredOrders.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Center(
                          child: Text(
                            l10n.noOrdersFound,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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

class _HistoryMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onTapNotifications;

  const _HistoryMainAppBar({
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
      actions: const [SizedBox(width: 6)],
    );
  }
}

class _HistoryHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final VoidCallback onAllReviews;

  const _HistoryHeaderCard({
    required this.title,
    required this.badgeText,
    required this.onAllReviews,
  });

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primary, primaryMid],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.16)),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: mint.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: mint.withOpacity(0.45)),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    fontSize: 11.8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAllReviews,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_border_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.allReviews,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownChip extends StatelessWidget {
  const _DropdownChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.10)),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: primary.withOpacity(0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: softMint,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: mint.withOpacity(0.50)),
              ),
              child: Icon(
                Icons.tune_rounded,
                size: 15,
                color: primary.withOpacity(0.78),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.72),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: primary.withOpacity(0.72),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.order, required this.onViewReview});

  final MealOrder order;
  final VoidCallback? onViewReview;

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  String _localizedMealType(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    final v = value.toLowerCase().trim();

    if (v == 'breakfast') return l10n.breakfast;
    if (v == 'lunch') return l10n.lunch;
    if (v == 'dinner') return l10n.dinner;
    if (v == 'healthy') return l10n.healthy;
    if (v == 'vegetarian') return l10n.vegetarian;
    if (v == 'high protein') return l10n.highProtein;
    if (v == 'low carb') return l10n.lowCarb;
    if (v == 'fast food') return l10n.fastFood;

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pill = _StatusPill.from(context, order.status);
    final languageCode = Localizations.localeOf(context).languageCode;
    final mealName = order.localizedMealName(languageCode);
    final mealType = order.localizedMealType(languageCode);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF9FCFB)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: primary.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [mint.withOpacity(0.95), primaryMid.withOpacity(0.75)],
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#${order.orderID}",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: primary.withOpacity(0.82),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          mealName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: primaryDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.pilgrimName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.black.withOpacity(0.70),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${order.campaignName} • ${order.campaignNumber}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: softMint,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: mint.withOpacity(0.55),
                                ),
                              ),
                              child: Text(
                                order.formattedRequestDate,
                                style: TextStyle(
                                  fontSize: 11.8,
                                  color: primary.withOpacity(0.85),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primary.withOpacity(0.16),
                                ),
                              ),
                              child: Text(
                                _localizedMealType(context, mealType),
                                style: TextStyle(
                                  fontSize: 11.8,
                                  color: primary.withOpacity(0.85),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 112,
                        height: 34,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: pill.bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: pill.border),
                          ),
                          child: Text(
                            pill.text,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: pill.fg,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (order.isReviewed)
                        SizedBox(
                          width: 112,
                          height: 34,
                          child: InkWell(
                            onTap: onViewReview,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: primary, width: 1.3),
                              ),
                              child: Text(
                                l10n.viewReview,
                                style: const TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill {
  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  const _StatusPill({
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  static _StatusPill from(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;

    switch (status.toLowerCase()) {
      case 'completed':
        return _StatusPill(
          text: l10n.completed,
          bg: const Color(0xFFE7F6ED),
          fg: const Color(0xFF1E7A3A),
          border: const Color(0xFFCBEBD6),
        );
      case 'rejected':
        return _StatusPill(
          text: l10n.rejected,
          bg: const Color(0xFFFFE9E9),
          fg: const Color(0xFFB3261E),
          border: const Color(0xFFFFC7C7),
        );
      case 'cancelled':
        return _StatusPill(
          text: l10n.cancelled,
          bg: const Color(0xFFF3F3F3),
          fg: const Color(0xFF666666),
          border: const Color(0xFFE0E0E0),
        );
      case 'pending':
        return _StatusPill(
          text: l10n.pending,
          bg: const Color(0xFFFFF6E5),
          fg: const Color(0xFF9A6700),
          border: const Color(0xFFFFE2A8),
        );
      case 'accepted':
        return _StatusPill(
          text: l10n.accepted,
          bg: const Color(0xFFE8F1FF),
          fg: const Color(0xFF2457C5),
          border: const Color(0xFFCFE0FF),
        );
      default:
        return _StatusPill(
          text: l10n.unknown,
          bg: const Color(0xFFF1F1F1),
          fg: const Color(0xFF666666),
          border: const Color(0xFFE0E0E0),
        );
    }
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return Icon(
          filled ? Icons.star : Icons.star_border,
          size: 18,
          color: filled ? const Color(0xFFF4D03F) : Colors.black38,
        );
      }),
    );
  }
}

class _ReviewViewSheet extends StatelessWidget {
  const _ReviewViewSheet({required this.order, required this.rate});

  final MealOrder order;
  final Rate rate;

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  String _formatDateTime(String value, AppLocalizations l10n) {
    if (value.trim().isEmpty) return l10n.notAvailable;

    try {
      final dt = DateTime.parse(value).toLocal();
      final dd = dt.day.toString().padLeft(2, '0');
      final mm = dt.month.toString().padLeft(2, '0');
      final yyyy = dt.year.toString();
      final hh = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$dd/$mm/$yyyy  •  $hh:$min';
    } catch (_) {
      return value;
    }
  }

  Widget _infoBox({
    required String title,
    required String value,
    required String emptyText,
    bool highlighted = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlighted ? softMint : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted
              ? mint.withOpacity(0.65)
              : Colors.black.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.black.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.trim().isEmpty ? emptyText : value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: primaryDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final mealName = order.localizedMealName(languageCode);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 44,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Text(
                "${l10n.reviewDetails} • #${order.orderID}",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                mealName,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(0.72),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${order.pilgrimName} • ${order.campaignName}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.55),
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: softMint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: mint.withOpacity(0.60)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF4B400),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    _Stars(rating: rate.stars),
                    const Spacer(),
                    Text(
                      "${rate.stars}/5",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _infoBox(
                title: l10n.pilgrimComment,
                value: rate.comment,
                emptyText: l10n.noTextProvided,
                highlighted: true,
              ),
              const SizedBox(height: 12),
              _infoBox(
                title: l10n.reviewDate,
                value: _formatDateTime(rate.reviewDateTime, l10n),
                emptyText: l10n.notAvailable,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderAllReviewsScreen extends StatefulWidget {
  const ProviderAllReviewsScreen({super.key, required this.orders});

  final List<MealOrder> orders;

  @override
  State<ProviderAllReviewsScreen> createState() =>
      _ProviderAllReviewsScreenState();
}

class _ProviderAllReviewsScreenState extends State<ProviderAllReviewsScreen> {
  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  DateTime? selectedReviewDate;
  String? selectedCampaignKey;
  String? selectedCampaignLabel;

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  String _campaignKey(MealOrder order) {
    return '${order.campaignName.trim()}|${order.campaignNumber.trim()}';
  }

  String _campaignLabel(MealOrder order) {
    final name = order.campaignName.trim();
    final number = order.campaignNumber.trim();

    if (name.isEmpty && number.isEmpty) return 'Campaign';
    if (number.isEmpty) return name;
    if (name.isEmpty) return number;
    return '$name • $number';
  }

  List<MealOrder> get _filteredReviews {
    final result = widget.orders.where((order) {
      final okDate = selectedReviewDate == null
          ? true
          : order.requestDate.year == selectedReviewDate!.year &&
                order.requestDate.month == selectedReviewDate!.month &&
                order.requestDate.day == selectedReviewDate!.day;

      final okCampaign = selectedCampaignKey == null
          ? true
          : _campaignKey(order) == selectedCampaignKey;

      return okDate && okCampaign;
    }).toList();

    result.sort((a, b) => b.requestDate.compareTo(a.requestDate));
    return result;
  }

  List<MealOrder> get _uniqueCampaignOrders {
    final map = <String, MealOrder>{};

    for (final order in widget.orders) {
      final key = _campaignKey(order);
      if (key.trim().replaceAll('|', '').isNotEmpty) {
        map[key] = order;
      }
    }

    final list = map.values.toList()
      ..sort((a, b) => _campaignLabel(a).compareTo(_campaignLabel(b)));

    return list;
  }

  Future<void> _pickDateFilter() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedReviewDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked == null) return;

    setState(() {
      selectedReviewDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<void> _pickCampaignFilter() async {
    final campaigns = _uniqueCampaignOrders;

    final picked = await showModalBottomSheet<MealOrder?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Campaign',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            ListTile(
              title: const Text('All Campaigns'),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ...campaigns.map(
              (order) => ListTile(
                title: Text(_campaignLabel(order)),
                onTap: () => Navigator.pop(ctx, order),
              ),
            ),
          ],
        ),
      ),
    );

    if (picked == null) {
      setState(() {
        selectedCampaignKey = null;
        selectedCampaignLabel = null;
      });
      return;
    }

    setState(() {
      selectedCampaignKey = _campaignKey(picked);
      selectedCampaignLabel = _campaignLabel(picked);
    });
  }

  void _clearFilters() {
    setState(() {
      selectedReviewDate = null;
      selectedCampaignKey = null;
      selectedCampaignLabel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final reviewedOrders = _filteredReviews;

    final dateLabel = selectedReviewDate == null
        ? 'Date'
        : _formatDate(selectedReviewDate!);

    final campaignLabel = selectedCampaignLabel ?? 'Campaign';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        automaticallyImplyLeading: false,
        titleSpacing: 4,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,
                size: 20,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              l10n.allReviews,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DropdownChip(
                        label: dateLabel,
                        onTap: _pickDateFilter,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DropdownChip(
                        label: campaignLabel,
                        onTap: _pickCampaignFilter,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${reviewedOrders.length} ${l10n.allReviews}',
                      style: TextStyle(
                        color: primary.withOpacity(0.75),
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: reviewedOrders.isEmpty
                ? Center(
                    child: Text(
                      l10n.noReviewsYet,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black45,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: reviewedOrders.length,
                    itemBuilder: (context, i) {
                      final order = reviewedOrders[i];
                      final mealName = order.localizedMealName(languageCode);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Color(0xFFF9FCFB)],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: primary.withOpacity(0.10)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 22,
                              offset: const Offset(0, 12),
                              color: primary.withOpacity(0.08),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8,
                                height: 110,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      mint.withOpacity(0.95),
                                      primaryMid.withOpacity(0.75),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "#${order.orderID}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: primary.withOpacity(0.82),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      mealName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                        color: primaryDark,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _Stars(rating: order.reviewRating ?? 0),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: softMint,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: mint.withOpacity(0.55),
                                        ),
                                      ),
                                      child: Text(
                                        "${order.pilgrimName} • ${order.campaignName}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
