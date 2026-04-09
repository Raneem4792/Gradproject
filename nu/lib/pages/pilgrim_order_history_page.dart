import 'package:flutter/material.dart';
import '../models/meal_order.dart';
import '../services/meal_service.dart';
import 'pilgrim_rate_meal_page.dart';
import '../widgets/pilgrim_bottom_nav.dart';
import 'pilgrim_home_screen.dart';
import 'pilgrim_meals_page.dart';
import 'pilgrim_profile_page.dart';
import '../session/user_session.dart';

class PilgrimOrderHistoryPage extends StatefulWidget {
  static const String routeName = '/pilgrim-order-history';

  const PilgrimOrderHistoryPage({super.key});

  @override
  State<PilgrimOrderHistoryPage> createState() =>
      _PilgrimOrderHistoryPageState();
}

class _PilgrimOrderHistoryPageState extends State<PilgrimOrderHistoryPage> {
  int _navIndex = 2;

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  final MealService _mealService = MealService();
  late Future<List<MealOrder>> _ordersFuture;

  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();

    final pilgrimId = UserSession.userId;

    if (pilgrimId == null) {
      throw Exception("User not logged in");
    }

    _ordersFuture = _mealService.getOrdersByPilgrim(pilgrimId);
  }

  List<Map<String, dynamic>> _mapOrders(List<MealOrder> apiOrders) {
    return apiOrders.map<Map<String, dynamic>>((order) {
      final status = order.status.toLowerCase();

      String uiStatus;
      if (status == "pending") {
        uiStatus = "Pending";
      } else if (status == "completed") {
        uiStatus = "Completed";
      } else if (status == "rejected") {
        uiStatus = "Rejected";
      } else if (status == "cancelled") {
        uiStatus = "Cancelled";
      } else if (status == "accepted") {
        uiStatus = "Accepted";
      } else {
        uiStatus = order.status;
      }

      return {
        "orderId": order.orderID.toString(),
        "mealName": order.mealName,
        "orderDate": order.formattedRequestDate,
        "orderStatus": uiStatus,
        "isReviewed": order.isReviewed,
        "reviewRating": order.reviewRating,
      };
    }).toList();
  }

  Future<void> _openRatePage(int index) async {
    if (orders[index]["orderStatus"] != "Completed") return;
    if (orders[index]["isReviewed"] == true) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PilgrimRateMealPage(
          orderId: orders[index]["orderId"],
          mealName: orders[index]["mealName"],
        ),
      ),
    );

    if (result == true) {
      final pilgrimId = UserSession.userId;
      if (pilgrimId == null) return;

      setState(() {
        _ordersFuture = _mealService.getOrdersByPilgrim(pilgrimId);
      });
    }
  }

  void _handleBottomNavTap(int i) {
    if (i == _navIndex) return;

    setState(() => _navIndex = i);

    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimHomeScreen()),
      );
    } else if (i == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimMealsPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: const _OrderHistoryAppBar(),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<MealOrder>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Error loading orders: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            orders = _mapOrders(snapshot.data ?? []);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HistoryHeroCard(),
                  const SizedBox(height: 18),
                  const _HistorySectionTitle(title: "Previous Orders"),
                  const SizedBox(height: 10),
                  if (orders.isEmpty)
                    const _EmptyOrdersState()
                  else
                    ...List.generate(
                      orders.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _OrderHistoryItemCard(
                          orderId: orders[index]["orderId"],
                          mealName: orders[index]["mealName"],
                          orderDate: orders[index]["orderDate"],
                          orderStatus: orders[index]["orderStatus"],
                          isReviewed: orders[index]["isReviewed"],
                          reviewRating: orders[index]["reviewRating"],
                          onRateTap: () => _openRatePage(index),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: PilgrimBottomNav(
        currentIndex: _navIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

class _OrderHistoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _OrderHistoryAppBar();

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
      titleSpacing: 8,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PilgrimHomeScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            "Order History",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryHeroCard extends StatelessWidget {
  const _HistoryHeroCard();

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryDark, primary, primaryMid],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Order History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Review your previous meal orders and rate completed meals.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -26,
            top: -26,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mint.withOpacity(0.10),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -38,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gold.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySectionTitle extends StatelessWidget {
  final String title;

  const _HistorySectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
    );
  }
}

class _OrderHistoryItemCard extends StatelessWidget {
  final String orderId;
  final String mealName;
  final String orderDate;
  final String orderStatus;
  final bool isReviewed;
  final int? reviewRating;
  final VoidCallback onRateTap;

  const _OrderHistoryItemCard({
    required this.orderId,
    required this.mealName,
    required this.orderDate,
    required this.orderStatus,
    required this.isReviewed,
    required this.reviewRating,
    required this.onRateTap,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = orderStatus == "Completed";
    final bool canRate = isCompleted && !isReviewed;

    final Color statusBg = isCompleted
        ? const Color(0xFFE9F7F2)
        : const Color(0xFFFFEFEA);
    final Color statusBorder = isCompleted
        ? mint.withOpacity(0.55)
        : const Color(0xFFFFC7B8);
    final Color statusText = isCompleted
        ? primary.withOpacity(0.95)
        : const Color(0xFFD6452D);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F2),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: primary.withOpacity(0.10)),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: primary.withOpacity(0.88),
              size: 30,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  "Order ID: $orderId",
                  style: TextStyle(
                    fontSize: 12.4,
                    color: Colors.black.withOpacity(0.60),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Date: $orderDate",
                  style: TextStyle(
                    fontSize: 12.4,
                    color: Colors.black.withOpacity(0.60),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: statusBorder),
                      ),
                      child: Text(
                        orderStatus,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: statusText,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isReviewed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.06),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Reviewed",
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900,
                                color: primary.withOpacity(0.88),
                              ),
                            ),
                            if (reviewRating != null) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: Color(0xFFF4B400),
                              ),
                              Text(
                                "$reviewRating",
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                  color: primary.withOpacity(0.88),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    else if (canRate)
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: onRateTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Rate Meal",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  const _EmptyOrdersState();

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 34,
            color: primary.withOpacity(0.75),
          ),
          const SizedBox(height: 10),
          const Text(
            "No orders found",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            "Your submitted meal requests will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.58),
            ),
          ),
        ],
      ),
    );
  }
}
