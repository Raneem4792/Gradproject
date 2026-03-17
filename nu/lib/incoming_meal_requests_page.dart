import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'provider_dashboard_page.dart';
import 'provider_notifications_page.dart';
import 'provider_total_requests_page.dart';

class IncomingMealRequestsPage extends StatefulWidget {
  static const String routeName = '/incoming-requests';

  const IncomingMealRequestsPage({super.key});

  @override
  State<IncomingMealRequestsPage> createState() =>
      _IncomingMealRequestsPageState();
}

class _IncomingMealRequestsPageState extends State<IncomingMealRequestsPage> {
  int _navIndex = 1;

  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);
  static const Color gold = Color(0xFFF0E0C0);

  final List<_ReqModel> _requests = [
    _ReqModel(
      mealName: "Meal Name",
      campaignNo: "Campaign number",
      hajName: "Haj name",
      time: "9:41 AM",
    ),
    _ReqModel(
      mealName: "Meal Name",
      campaignNo: "Campaign number",
      hajName: "Haj name",
      time: "9:41 AM",
    ),
    _ReqModel(
      mealName: "Meal Name",
      campaignNo: "Campaign number",
      hajName: "Haj name",
      time: "9:41 AM",
    ),
  ];

  void _openTotalRequestsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProviderTotalRequestsPage()),
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
    } else if (i == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderDashboardPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacementNamed(context, '/providerProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _RequestsMainAppBar(onBack: _handleBack),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RequestsHeaderCard(
                title: "Requests list",
                badgeText: "${_requests.length} new",
              ),
              const SizedBox(height: 16),
              ListView.separated(
                itemCount: _requests.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final r = _requests[i];
                  return _IncomingRequestCardGreen(
                    mealName: r.mealName,
                    campaignNo: r.campaignNo,
                    hajName: r.hajName,
                    time: r.time,
                    onAccept: () => HapticFeedback.selectionClick(),
                    onReject: () => HapticFeedback.selectionClick(),
                  );
                },
              ),
              const SizedBox(height: 20),
              _SectionHeaderRow(
                title: "Total requests",
                onTapArrow: _openTotalRequestsPage,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 156,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return const _TotalRequestBoxGreen(
                      mealName: "Meal Name",
                      pieces: "NO of requests",
                    );
                  },
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

/// =======================
/// APP BAR
/// =======================
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

/// =======================
/// HEADER CARD
/// =======================
class _RequestsHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;

  const _RequestsHeaderCard({required this.title, required this.badgeText});

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
            child: const Icon(
              Icons.inbox_rounded,
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

/// =======================
/// Request Card
/// =======================
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
                label: "Reject",
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
          width: 96,
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

/// =======================
/// Total requests header row
/// =======================
class _SectionHeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback onTapArrow;

  const _SectionHeaderRow({required this.title, required this.onTapArrow});

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
            color: primary,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onTapArrow,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: primary.withOpacity(0.78),
            ),
          ),
        ),
      ],
    );
  }
}

/// =======================
/// Total request box
/// =======================
class _TotalRequestBoxGreen extends StatelessWidget {
  final String mealName;
  final String pieces;

  const _TotalRequestBoxGreen({required this.mealName, required this.pieces});

  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 146,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(0.09)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: primary.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealName,
            style: const TextStyle(
              fontSize: 12.8,
              fontWeight: FontWeight.w900,
              color: primary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [softMint, mint.withOpacity(0.34)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: mint.withOpacity(0.58)),
            ),
            child: Center(
              child: Icon(
                Icons.restaurant_menu_rounded,
                color: primaryMid.withOpacity(0.85),
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            pieces,
            style: TextStyle(
              fontSize: 11.6,
              fontWeight: FontWeight.w700,
              color: Colors.black.withOpacity(0.60),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReqModel {
  final String mealName;
  final String campaignNo;
  final String hajName;
  final String time;

  _ReqModel({
    required this.mealName,
    required this.campaignNo,
    required this.hajName,
    required this.time,
  });
}
