import 'package:flutter/material.dart';

class ProviderHistoryScreen extends StatefulWidget {
  const ProviderHistoryScreen({super.key});
  static const routeName = '/provider-history';

  @override
  State<ProviderHistoryScreen> createState() => _ProviderHistoryScreenState();
}

class _ProviderHistoryScreenState extends State<ProviderHistoryScreen> {
  // ===== Shared palette to match IncomingMealRequestsPage =====
  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  // Filter labels
  String selectedDate = 'Date';
  String selectedCampaign = 'Campaign';
  String selectedMealType = 'Meal';
  String selectedStatus = 'Status';

  // Filter values (null = All)
  DateTime? selectedDateValue;
  String? selectedCampaignValue;
  _MealType? selectedMealTypeValue;
  _Status? selectedStatusValue;

  final List<_HistoryItem> items = const [
    _HistoryItem(
      orderId: 'ORD-1001',
      date: '12/01/2026',
      mealName: 'Chicken Kabsa',
      mealType: _MealType.lunch,
      campaignName: 'Nusuq Elite',
      campaignNumber: 'CAMP-01',
      status: _Status.completed,
    ),
    _HistoryItem(
      orderId: 'ORD-1002',
      date: '12/01/2026',
      mealName: 'Beef Burger Meal',
      mealType: _MealType.dinner,
      campaignName: 'Nusuq Elite',
      campaignNumber: 'CAMP-01',
      status: _Status.completed,
    ),
    _HistoryItem(
      orderId: 'ORD-1003',
      date: '11/01/2026',
      mealName: 'Cheese Omelette Box',
      mealType: _MealType.breakfast,
      campaignName: 'Makkah Hosts',
      campaignNumber: 'CAMP-02',
      status: _Status.rejected,
    ),
    _HistoryItem(
      orderId: 'ORD-1004',
      date: '10/01/2026',
      mealName: 'Fish Rice Meal',
      mealType: _MealType.lunch,
      campaignName: 'Rahma Group',
      campaignNumber: 'CAMP-03',
      status: _Status.completed,
    ),
    _HistoryItem(
      orderId: 'ORD-1005',
      date: '10/01/2026',
      mealName: 'Mandi Lamb Box',
      mealType: _MealType.dinner,
      campaignName: 'Al-Noor Campaign',
      campaignNumber: 'CAMP-04',
      status: _Status.rejected,
    ),
  ];

  late List<_HistoryItem> filteredItems;

  final Map<String, _Review> _reviewsByOrderId = {
    'ORD-1001': const _Review(rating: 5, comment: 'Very tasty!'),
    'ORD-1002': const _Review(rating: 4, comment: 'Good, but a bit salty.'),
  };

  int _navIndex = 2;

  @override
  void initState() {
    super.initState();
    filteredItems = List<_HistoryItem>.from(items);
  }

  DateTime? _parseDate(String ddMMyyyy) {
    try {
      final parts = ddMMyyyy.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  String _mealTypeLabel(_MealType t) {
    switch (t) {
      case _MealType.breakfast:
        return 'Breakfast';
      case _MealType.lunch:
        return 'Lunch';
      case _MealType.dinner:
        return 'Dinner';
    }
  }

  String _statusLabel(_Status s) {
    switch (s) {
      case _Status.completed:
        return 'Completed';
      case _Status.rejected:
        return 'Rejected';
    }
  }

  void applyFilters() {
    final result = items.where((item) {
      final okDate = selectedDateValue == null
          ? true
          : (() {
              final d = _parseDate(item.date);
              if (d == null) return false;
              return d.year == selectedDateValue!.year &&
                  d.month == selectedDateValue!.month &&
                  d.day == selectedDateValue!.day;
            })();

      final okCampaign = selectedCampaignValue == null
          ? true
          : item.campaignName == selectedCampaignValue;

      final okMealType = selectedMealTypeValue == null
          ? true
          : item.mealType == selectedMealTypeValue;

      final okStatus = selectedStatusValue == null
          ? true
          : item.status == selectedStatusValue;

      return okDate && okCampaign && okMealType && okStatus;
    }).toList();

    setState(() => filteredItems = result);
  }

  void clearFilters() {
    setState(() {
      selectedDateValue = null;
      selectedCampaignValue = null;
      selectedMealTypeValue = null;
      selectedStatusValue = null;

      selectedDate = 'Date';
      selectedCampaign = 'Campaign';
      selectedMealType = 'Meal';
      selectedStatus = 'Status';

      filteredItems = List<_HistoryItem>.from(items);
    });
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
      selectedDate = _formatDate(clean);
    });
    applyFilters();
  }

  Future<void> pickCampaignFilter() async {
    final campaigns = items.map((e) => e.campaignName).toSet().toList()..sort();

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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Select Campaign",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            ListTile(
              title: const Text("All Campaigns"),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ...campaigns.map(
              (c) =>
                  ListTile(title: Text(c), onTap: () => Navigator.pop(ctx, c)),
            ),
          ],
        ),
      ),
    );

    setState(() {
      selectedCampaignValue = picked;
      selectedCampaign = picked ?? 'Campaign';
    });
    applyFilters();
  }

  Future<void> pickMealTypeFilter() async {
    final picked = await showModalBottomSheet<_MealType?>(
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
                "Select Meal Type",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            ListTile(
              title: const Text("All"),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ListTile(
              title: const Text("Breakfast"),
              onTap: () => Navigator.pop(ctx, _MealType.breakfast),
            ),
            ListTile(
              title: const Text("Lunch"),
              onTap: () => Navigator.pop(ctx, _MealType.lunch),
            ),
            ListTile(
              title: const Text("Dinner"),
              onTap: () => Navigator.pop(ctx, _MealType.dinner),
            ),
          ],
        ),
      ),
    );

    setState(() {
      selectedMealTypeValue = picked;
      selectedMealType = picked == null ? 'Meal' : _mealTypeLabel(picked);
    });
    applyFilters();
  }

  Future<void> pickStatusFilter() async {
    final picked = await showModalBottomSheet<_Status?>(
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
                "Select Status",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            ListTile(
              title: const Text("All"),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ListTile(
              title: const Text("Completed"),
              onTap: () => Navigator.pop(ctx, _Status.completed),
            ),
            ListTile(
              title: const Text("Rejected"),
              onTap: () => Navigator.pop(ctx, _Status.rejected),
            ),
          ],
        ),
      ),
    );

    setState(() {
      selectedStatusValue = picked;
      selectedStatus = picked == null ? 'Status' : _statusLabel(picked);
    });
    applyFilters();
  }

  void _openAllReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProviderAllReviewsScreen(
          allOrders: items,
          reviewsByOrderId: _reviewsByOrderId,
          onReplySaved: (orderId, replyText) {
            final old = _reviewsByOrderId[orderId];
            if (old == null) return;
            setState(() {
              _reviewsByOrderId[orderId] = old.copyWith(reply: replyText);
            });
          },
        ),
      ),
    );
  }

  Future<void> _openReviewBottomSheet(_HistoryItem order) async {
    final review = _reviewsByOrderId[order.orderId];
    if (review == null) return;

    final reply = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => _ReviewViewSheet(
        orderId: order.orderId,
        mealName: order.mealName,
        review: review,
      ),
    );

    if (reply == null) return;

    setState(() {
      _reviewsByOrderId[order.orderId] = review.copyWith(reply: reply);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _HistoryMainAppBar(onBack: () => Navigator.pop(context)),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HistoryHeaderCard(
                      title: "Order History",
                      badgeText: "${filteredItems.length} orders",
                      onAllReviews: _openAllReviews,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _DropdownChip(
                            label: selectedDate,
                            onTap: pickDateFilter,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DropdownChip(
                            label: selectedCampaign,
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
                            label: selectedMealType,
                            onTap: pickMealTypeFilter,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DropdownChip(
                            label: selectedStatus,
                            onTap: pickStatusFilter,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: clearFilters,
                        child: const Text(
                          "Clear",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    ...filteredItems.map((e) {
                      final review = _reviewsByOrderId[e.orderId];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _HistoryCard(
                          item: e,
                          review: review,
                          onViewReview: review == null
                              ? null
                              : () => _openReviewBottomSheet(e),
                        ),
                      );
                    }),

                    if (filteredItems.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(
                          child: Text(
                            "No orders found",
                            style: TextStyle(
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
          ],
        ),
      ),
      bottomNavigationBar: _ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// هذا الكلاس حق الـ AppBar الرئيسي بنفس ستايل صفحة الطلبات
class _HistoryMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _HistoryMainAppBar({required this.onBack});

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
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
            color: Colors.black87,
            size: 20,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.black87, size: 20),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

// هذا الكلاس حق الهيدر الرئيسي للصفحة بنفس هوية الصفحة الأولى
class _HistoryHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final VoidCallback onAllReviews;

  const _HistoryHeaderCard({
    required this.title,
    required this.badgeText,
    required this.onAllReviews,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Container(
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_border_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "All Reviews",
                        style: TextStyle(
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

// هذا الكلاس حق فلتر الاختيارات بشكل متناسق مع نفس الستايل
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

// هذا الكلاس حق كرت الطلب في سجل التاريخ بنفس نفسية الكروت الأولى
class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.item,
    required this.review,
    required this.onViewReview,
  });

  final _HistoryItem item;
  final _Review? review;
  final VoidCallback? onViewReview;

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    final pill = _StatusPill.from(item.status);

    final isCompleted = item.status == _Status.completed;
    final canOpenReview = isCompleted && review != null;

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
            height: 122,
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
                          "#${item.orderId}",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: primary.withOpacity(0.82),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.mealName,
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
                          "${item.campaignName} • ${item.campaignNumber}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: softMint,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mint.withOpacity(0.55)),
                          ),
                          child: Text(
                            item.date,
                            style: TextStyle(
                              fontSize: 11.8,
                              color: primary.withOpacity(0.85),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
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
                      if (isCompleted)
                        SizedBox(
                          width: 112,
                          height: 34,
                          child: InkWell(
                            onTap: canOpenReview ? onViewReview : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: canOpenReview
                                      ? primary
                                      : Colors.grey.shade400,
                                  width: 1.3,
                                ),
                              ),
                              child: Text(
                                "View Review",
                                style: TextStyle(
                                  color: canOpenReview
                                      ? primary
                                      : Colors.grey.shade600,
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

// هذا الكلاس حق عرض النجوم للتقييم
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
          size: 16,
          color: filled ? const Color(0xFFF4D03F) : Colors.black38,
        );
      }),
    );
  }
}

// هذا الكلاس حق الـ BottomNavigationBar بنفس شكل الصفحة المرجعية
class _ProviderBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ProviderBottomNav({required this.currentIndex, required this.onTap});

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.black.withOpacity(0.42),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu_rounded),
          label: "Meals",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_rounded),
          label: "History",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}

// هذا الإنم حق حالات الطلب
enum _Status { completed, rejected }

// هذا الإنم حق أنواع الوجبات
enum _MealType { breakfast, lunch, dinner }

// هذا المودل حق عنصر واحد من سجل الطلبات
class _HistoryItem {
  final String orderId;
  final String date;
  final String mealName;
  final _MealType mealType;
  final String campaignName;
  final String campaignNumber;
  final _Status status;

  const _HistoryItem({
    required this.orderId,
    required this.date,
    required this.mealName,
    required this.mealType,
    required this.campaignName,
    required this.campaignNumber,
    required this.status,
  });
}

// هذا الكلاس حق تصميم شارة الحالة Completed / Rejected
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

  static _StatusPill from(_Status s) {
    switch (s) {
      case _Status.completed:
        return const _StatusPill(
          text: "Completed",
          bg: Color(0xFFE7F6ED),
          fg: Color(0xFF1E7A3A),
          border: Color(0xFFCBEBD6),
        );
      case _Status.rejected:
        return const _StatusPill(
          text: "Rejected",
          bg: Color(0xFFFFE9E9),
          fg: Color(0xFFB3261E),
          border: Color(0xFFFFC7C7),
        );
    }
  }
}

// هذا المودل حق التقييم والتعليق والرد
class _Review {
  final int rating;
  final String comment;
  final String? reply;

  const _Review({required this.rating, required this.comment, this.reply});

  _Review copyWith({int? rating, String? comment, String? reply}) {
    return _Review(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      reply: reply ?? this.reply,
    );
  }
}

// هذا الكلاس حق البوتوم شيت لعرض التقييم وكتابة الرد
class _ReviewViewSheet extends StatefulWidget {
  const _ReviewViewSheet({
    required this.orderId,
    required this.mealName,
    required this.review,
  });

  final String orderId;
  final String mealName;
  final _Review review;

  @override
  State<_ReviewViewSheet> createState() => _ReviewViewSheetState();
}

class _ReviewViewSheetState extends State<_ReviewViewSheet> {
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  late final TextEditingController replyController;

  @override
  void initState() {
    super.initState();
    replyController = TextEditingController(text: widget.review.reply ?? '');
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                "Review • #${widget.orderId}",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.mealName,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.70),
                ),
              ),
              const SizedBox(height: 12),
              _Stars(rating: widget.review.rating),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: softMint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: mint.withOpacity(0.55)),
                ),
                child: Text(
                  widget.review.comment,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your reply",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: replyController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write a reply...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primary.withOpacity(0.12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primary.withOpacity(0.12)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: primary, width: 1.2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        side: BorderSide(color: primary.withOpacity(0.16)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: primary.withOpacity(0.86),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryDark, primary, Color(0xFF167062)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                            color: primary.withOpacity(0.22),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context, replyController.text.trim()),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Save Reply",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
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
    );
  }
}

// هذا الكلاس حق صفحة كل التقييمات
class ProviderAllReviewsScreen extends StatelessWidget {
  const ProviderAllReviewsScreen({
    super.key,
    required this.allOrders,
    required this.reviewsByOrderId,
    required this.onReplySaved,
  });

  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  final List<_HistoryItem> allOrders;
  final Map<String, _Review> reviewsByOrderId;
  final void Function(String orderId, String replyText) onReplySaved;

  @override
  Widget build(BuildContext context) {
    final entries = reviewsByOrderId.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

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
            const Text(
              "All Reviews",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                "No reviews yet",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black45,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final orderId = entries[i].key;
                final review = entries[i].value;

                final order =
                    allOrders.where((e) => e.orderId == orderId).isEmpty
                    ? null
                    : allOrders.firstWhere((e) => e.orderId == orderId);

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
                  child: InkWell(
                    onTap: () async {
                      final reply = await showModalBottomSheet<String?>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                        ),
                        builder: (_) => _ReviewViewSheet(
                          orderId: orderId,
                          mealName: order?.mealName ?? "Meal",
                          review: review,
                        ),
                      );

                      if (reply == null) return;
                      onReplySaved(orderId, reply);
                    },
                    borderRadius: BorderRadius.circular(22),
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
                                  "#$orderId",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: primary.withOpacity(0.82),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  order?.mealName ?? "Meal",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    color: primaryDark,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _Stars(rating: review.rating),
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
                                    review.comment,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  review.reply == null || review.reply!.isEmpty
                                      ? "Tap to reply"
                                      : "Reply: ${review.reply}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black.withOpacity(0.60),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
