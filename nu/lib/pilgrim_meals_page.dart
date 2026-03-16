import 'package:flutter/material.dart';
import 'pilgrim_submit_meal_request_page.dart';

class PilgrimMealsPage extends StatefulWidget {
  static const String routeName = '/pilgrim-meals';

  const PilgrimMealsPage({super.key});

  @override
  State<PilgrimMealsPage> createState() => _PilgrimMealsPageState();
}

class _PilgrimMealsPageState extends State<PilgrimMealsPage> {
  int _navIndex = 1;
  bool showRecommendedOnly = true;

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  final List<Map<String, dynamic>> meals = const [
    {
      "title": "Grilled Chicken Salad",
      "providerName": "Al Noor Catering",
      "mealType": "Lunch",
      "description": "Fresh grilled chicken with greens and light dressing.",
      "nutritionLine": "420 kcal • 32g protein • 18g carbs • 14g fat",
      "isHealthMatched": true,
      "icon": Icons.restaurant_menu_rounded,
    },
    {
      "title": "Baked Fish with Rice",
      "providerName": "Al Barakah Kitchen",
      "mealType": "Dinner",
      "description":
          "Healthy baked fish served with white rice and vegetables.",
      "nutritionLine": "510 kcal • 35g protein • 40g carbs • 16g fat",
      "isHealthMatched": true,
      "icon": Icons.set_meal_rounded,
    },
    {
      "title": "Vegetable Soup & Bread",
      "providerName": "Rahma Food Service",
      "mealType": "Breakfast",
      "description": "Warm soup with soft bread, light and easy to digest.",
      "nutritionLine": "280 kcal • 9g protein • 30g carbs • 7g fat",
      "isHealthMatched": false,
      "icon": Icons.soup_kitchen_rounded,
    },
  ];

  void _openSubmitMealRequestPage({
    required String title,
    required String description,
    required String providerName,
    required String nutritionLine,
    required IconData icon,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PilgrimSubmitMealRequestPage(
          mealName: title,
          mealDescription: description,
          providerName: providerName,
          nutritionLine: nutritionLine,
          mealIcon: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleMeals = showRecommendedOnly
        ? meals.where((meal) => meal["isHealthMatched"] == true).toList()
        : meals;

    return Scaffold(
      backgroundColor: bg,
      appBar: const _PilgrimMealsAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MealsHeroCard(),
              const SizedBox(height: 18),

              const _MealsSectionTitle(title: "Smart Filters"),
              const SizedBox(height: 10),

              _MealFilterBar(
                showRecommendedOnly: showRecommendedOnly,
                onSelectRecommended: () {
                  setState(() => showRecommendedOnly = true);
                },
                onSelectAll: () {
                  setState(() => showRecommendedOnly = false);
                },
              ),

              const SizedBox(height: 16),

              _MealsSectionTitle(
                title: showRecommendedOnly
                    ? "AI Recommended Meals"
                    : "All Available Meals",
              ),
              const SizedBox(height: 10),

              if (visibleMeals.isEmpty)
                const _EmptyMealsState()
              else
                ...visibleMeals.map(
                  (meal) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MealRequestCard(
                      title: meal["title"],
                      providerName: meal["providerName"],
                      mealType: meal["mealType"],
                      description: meal["description"],
                      nutritionLine: meal["nutritionLine"],
                      isHealthMatched: meal["isHealthMatched"],
                      icon: meal["icon"],
                      onSelectMeal: () {
                        _openSubmitMealRequestPage(
                          title: meal["title"],
                          description: meal["description"],
                          providerName: meal["providerName"],
                          nutritionLine: meal["nutritionLine"],
                          icon: meal["icon"],
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _MealsBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
        },
      ),
    );
  }
}

class _PilgrimMealsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _PilgrimMealsAppBar();

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
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            "Meals",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.black87, size: 20),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

class _MealsHeroCard extends StatelessWidget {
  const _MealsHeroCard();

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
                    Icons.restaurant_menu_rounded,
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
                        "Select Your Meal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Browse meals, review nutrition and choose what fits your health needs.",
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

class _MealsSectionTitle extends StatelessWidget {
  final String title;

  const _MealsSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _MealFilterBar extends StatelessWidget {
  final bool showRecommendedOnly;
  final VoidCallback onSelectRecommended;
  final VoidCallback onSelectAll;

  const _MealFilterBar({
    required this.showRecommendedOnly,
    required this.onSelectRecommended,
    required this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterChipButton(
            label: "AI Recommended",
            icon: Icons.auto_awesome_rounded,
            isSelected: showRecommendedOnly,
            onTap: onSelectRecommended,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FilterChipButton(
            label: "All Meals",
            icon: Icons.grid_view_rounded,
            isSelected: !showRecommendedOnly,
            onTap: onSelectAll,
          ),
        ),
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primary : Colors.black.withOpacity(0.06),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.04),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : primary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealRequestCard extends StatelessWidget {
  final String title;
  final String providerName;
  final String mealType;
  final String description;
  final String nutritionLine;
  final bool isHealthMatched;
  final IconData icon;
  final VoidCallback onSelectMeal;

  const _MealRequestCard({
    required this.title,
    required this.providerName,
    required this.mealType,
    required this.description,
    required this.nutritionLine,
    required this.isHealthMatched,
    required this.icon,
    required this.onSelectMeal,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softBg = Color(0xFFEAF4F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHealthMatched
              ? mint.withOpacity(0.85)
              : Colors.black.withOpacity(0.05),
          width: isHealthMatched ? 1.3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    softBg,
                    mint.withOpacity(0.35),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.04),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 42,
                        color: primary.withOpacity(0.9),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.82),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        mealType,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: primaryDark.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                  if (isHealthMatched)
                    Positioned(
                      right: 14,
                      bottom: 14,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                              color: primary.withOpacity(0.22),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Provided by $providerName",
                  style: TextStyle(
                    fontSize: 12.2,
                    color: Colors.black.withOpacity(0.58),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Colors.black.withOpacity(0.68),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAF9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monitor_heart_outlined,
                        size: 16,
                        color: primary.withOpacity(0.85),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          nutritionLine,
                          style: TextStyle(
                            fontSize: 11.8,
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSelectMeal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Select Meal",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12.8,
                      ),
                    ),
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

class _EmptyMealsState extends StatelessWidget {
  const _EmptyMealsState();

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
            Icons.search_off_rounded,
            size: 34,
            color: primary.withOpacity(0.75),
          ),
          const SizedBox(height: 10),
          const Text(
            "No recommended meals found",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Try viewing all meals instead.",
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

class _MealsBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MealsBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  static const Color primary = Color(0xFF0D4C4A);

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
          icon: Icon(Icons.restaurant_menu),
          label: "Meals",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}