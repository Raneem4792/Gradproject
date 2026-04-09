import 'package:flutter/material.dart';
import '../widgets/provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'provider_dashboard_page.dart';
import '../session/user_session.dart';
import '../models/meal_order.dart';
import '../services/meal_service.dart';

class IncomingMealRequestsPage extends StatefulWidget {
  static const String routeName = '/incoming-requests';

  const IncomingMealRequestsPage({super.key});

  @override
  State<IncomingMealRequestsPage> createState() =>
      _IncomingMealRequestsPageState();
}

class _IncomingMealRequestsPageState extends State<IncomingMealRequestsPage> {
  int _navIndex = 1;
  int _selectedTabIndex = 0; // 0 = incoming, 1 = accepted

  final MealService _mealService = MealService();
  late Future<List<MealOrder>> _requestsFuture;

  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    _requestsFuture = _mealService.getOrdersByProvider(UserSession.userId!);
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
    } else if (i == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderDashboardPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacementNamed(context, '/providerProfile');
    }
  }

  Future<void> _acceptRequest(int orderID) async {
    try {
      final message = await _mealService.updateOrderStatus(
        orderID: orderID,
        status: 'accepted',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      setState(() {
        _selectedTabIndex = 1; // يروح تلقائي لتبويب Accepted
        _loadRequests();
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to accept request: $e')));
    }
  }

  Future<void> _rejectRequest(int orderID) async {
    try {
      final message = await _mealService.updateOrderStatus(
        orderID: orderID,
        status: 'cancelled',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      setState(() {
        _loadRequests();
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to cancel request: $e')));
    }
  }

  Future<void> _updateAcceptedOrderStatus(int orderID, String newStatus) async {
    try {
      final message = await _mealService.updateOrderStatus(
        orderID: orderID,
        status: newStatus,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      setState(() {
        _loadRequests();
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update request: $e')),
      );
    }
  }

  Future<void> _showAcceptedStatusMenu(int orderID) async {
    final selectedStatus = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Change Order Status',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: primaryDark,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline_rounded),
                  title: const Text(
                    'completed',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () => Navigator.pop(context, 'completed'),
                ),
                ListTile(
                  leading: const Icon(Icons.cancel_outlined),
                  title: const Text(
                    'cancelled',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () => Navigator.pop(context, 'cancelled'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedStatus != null) {
      await _updateAcceptedOrderStatus(orderID, selectedStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _RequestsMainAppBar(onBack: _handleBack),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<MealOrder>>(
          future: _requestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Error loading requests: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final allRequests = snapshot.data ?? [];

            final pendingRequests = allRequests
                .where((req) => req.status.toLowerCase() == 'pending')
                .toList();

            final acceptedRequests = allRequests
                .where((req) => req.status.toLowerCase() == 'accepted')
                .toList();

            final isIncomingTab = _selectedTabIndex == 0;
            final currentRequests =
                isIncomingTab ? pendingRequests : acceptedRequests;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RequestsHeaderCard(
                    title: isIncomingTab
                        ? "Incoming Requests"
                        : "Accepted Orders",
                    badgeText: isIncomingTab
                        ? "${pendingRequests.length} New"
                        : "${acceptedRequests.length} Accepted",
                    icon: isIncomingTab
                        ? Icons.inbox_rounded
                        : Icons.check_circle_outline_rounded,
                  ),
                  const SizedBox(height: 16),

                  _RequestsTabSwitcher(
                    selectedIndex: _selectedTabIndex,
                    incomingCount: pendingRequests.length,
                    acceptedCount: acceptedRequests.length,
                    onChanged: (index) {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  if (currentRequests.isEmpty)
                    _EmptyRequestsCard(
                      message: isIncomingTab
                          ? 'No incoming requests yet'
                          : 'No accepted orders yet',
                    )
                  else
                    ...currentRequests.map(
                      (req) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: isIncomingTab
                            ? _IncomingRequestCardGreen(
                                mealName: req.mealName,
                                campaignNo: req.campaignNumber.isEmpty
                                    ? req.campaignName
                                    : req.campaignNumber,
                                hajName: req.pilgrimName,
                                time: req.formattedRequestDate,
                                onAccept: () => _acceptRequest(req.orderID),
                                onReject: () => _rejectRequest(req.orderID),
                              )
                            : _AcceptedRequestCard(
                                mealName: req.mealName,
                                campaignNo: req.campaignNumber.isEmpty
                                    ? req.campaignName
                                    : req.campaignNumber,
                                hajName: req.pilgrimName,
                                time: req.formattedRequestDate,
                                onTapStatus: () =>
                                    _showAcceptedStatusMenu(req.orderID),
                              ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

class _RequestsMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _RequestsMainAppBar({required this.onBack});

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

class _RequestsHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final IconData icon;

  const _RequestsHeaderCard({
    required this.title,
    required this.badgeText,
    required this.icon,
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
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.16)),
            ),
            child: Icon(
              icon,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }
}

class _RequestsTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final int incomingCount;
  final int acceptedCount;
  final ValueChanged<int> onChanged;

  const _RequestsTabSwitcher({
    required this.selectedIndex,
    required this.incomingCount,
    required this.acceptedCount,
    required this.onChanged,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabOption(
              title: 'Incoming',
              count: incomingCount,
              isSelected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TabOption(
              title: 'Accepted',
              count: acceptedCount,
              isSelected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabOption extends StatelessWidget {
  final String title;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabOption({
    required this.title,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryDark, primary, primaryMid],
                  )
                : null,
            color: isSelected ? null : softMint,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : primary.withOpacity(0.08),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                      color: primary.withOpacity(0.20),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.16)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withOpacity(0.20)
                        : primary.withOpacity(0.08),
                  ),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncomingRequestCardGreen extends StatelessWidget {
  final String mealName;
  final String campaignNo;
  final String hajName;
  final String time;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _IncomingRequestCardGreen({
    required this.mealName,
    required this.campaignNo,
    required this.hajName,
    required this.time,
    required this.onAccept,
    required this.onReject,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
            height: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [mint.withOpacity(0.95), primaryMid.withOpacity(0.75)],
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
                  mealName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: primaryDark,
                  ),
                ),
                const SizedBox(height: 6),
                _InfoLine(icon: Icons.flag_outlined, text: campaignNo),
                const SizedBox(height: 5),
                _InfoLine(icon: Icons.person_outline, text: hajName),
                const SizedBox(height: 8),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: primary.withOpacity(0.75),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11.8,
                          color: primary.withOpacity(0.85),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              _ActionButton(
                label: "Accept",
                icon: Icons.check_rounded,
                isPrimary: true,
                onTap: onAccept,
              ),
              const SizedBox(height: 10),
              _ActionButton(
                label: "Cancel",
                icon: Icons.close_rounded,
                isPrimary: false,
                onTap: onReject,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AcceptedRequestCard extends StatelessWidget {
  final String mealName;
  final String campaignNo;
  final String hajName;
  final String time;
  final VoidCallback onTapStatus;

  const _AcceptedRequestCard({
    required this.mealName,
    required this.campaignNo,
    required this.hajName,
    required this.time,
    required this.onTapStatus,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
            height: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryMid.withOpacity(0.95),
                  primaryDark.withOpacity(0.85),
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
                  mealName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: primaryDark,
                  ),
                ),
                const SizedBox(height: 6),
                _InfoLine(icon: Icons.flag_outlined, text: campaignNo),
                const SizedBox(height: 5),
                _InfoLine(icon: Icons.person_outline, text: hajName),
                const SizedBox(height: 8),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: primary.withOpacity(0.75),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11.8,
                          color: primary.withOpacity(0.85),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _ActionButton(
            label: "Accepted",
            icon: Icons.keyboard_arrow_down_rounded,
            isPrimary: true,
            onTap: onTapStatus,
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: primary.withOpacity(0.60)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.6,
              color: Colors.black.withOpacity(0.62),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);

  @override
  Widget build(BuildContext context) {
    final gradient = isPrimary
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryDark, primary, primaryMid],
          )
        : null;

    final bgColor = isPrimary ? null : Colors.white;
    final borderColor = isPrimary
        ? Colors.transparent
        : primary.withOpacity(0.14);
    final fgColor = isPrimary ? Colors.white : primary.withOpacity(0.86);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 104,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          decoration: BoxDecoration(
            gradient: gradient,
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                      color: primary.withOpacity(0.22),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: fgColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.2,
                  fontWeight: FontWeight.w900,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRequestsCard extends StatelessWidget {
  final String message;

  const _EmptyRequestsCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}