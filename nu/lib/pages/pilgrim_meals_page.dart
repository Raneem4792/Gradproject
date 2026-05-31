import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import 'pilgrim_submit_meal_request_page.dart';
import 'pilgrim_home_screen.dart';
import 'pilgrim_order_history_page.dart';
import 'pilgrim_profile_page.dart';
import '../widgets/pilgrim_bottom_nav.dart';
import '../session/user_session.dart';

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

  final MealService _mealService = MealService();
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _loadAiRecommendedMeals();
  }

  void _loadAiRecommendedMeals() {
    final pilgrimID = UserSession.userId;

    if (pilgrimID == null || pilgrimID.isEmpty) {
      _mealsFuture = Future.error('User is not logged in');
      return;
    }

    _mealsFuture = _mealService.getAiRecommendedMeals(pilgrimID);
  }

  void _loadAllMeals() {
    final pilgrimID = UserSession.userId;

    if (pilgrimID == null || pilgrimID.isEmpty) {
      _mealsFuture = Future.error('User is not logged in');
      return;
    }

    _mealsFuture = _mealService.getMealsByPilgrimCampaign(pilgrimID);
  }

  IconData _getMealIcon(dynamic mealType) {
    final type = (mealType ?? '').toString().toLowerCase();

    switch (type) {
      case 'breakfast':
        return Icons.breakfast_dining_rounded;
      case 'lunch':
        return Icons.lunch_dining_rounded;
      case 'dinner':
        return Icons.dinner_dining_rounded;
      case 'healthy':
        return Icons.eco_rounded;
      case 'fast food':
        return Icons.fastfood_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  String _localizedMealType(BuildContext context, String mealType) {
    final l10n = AppLocalizations.of(context)!;
    final type = mealType.toLowerCase().trim();

    switch (type) {
      case 'healthy':
        return l10n.healthy;
      case 'breakfast':
        return l10n.breakfast;
      case 'lunch':
        return l10n.lunch;
      case 'dinner':
        return l10n.dinner;
      case 'vegetarian':
        return l10n.vegetarian;
      case 'high protein':
        return l10n.highProtein;
      case 'low carb':
        return l10n.lowCarb;
      case 'fast food':
        return l10n.fastFood;
      default:
        return mealType;
    }
  }

  void _openSubmitMealRequestPage({
    required int mealID,
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
          mealID: mealID,
          mealName: title,
          mealDescription: description,
          providerName: providerName,
          nutritionLine: nutritionLine,
          mealIcon: icon,
        ),
      ),
    );
  }

  void _handleBottomNavTap(int i) {
    if (i == _navIndex) return;

    setState(() => _navIndex = i);

    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimHomeScreen()),
      );
    } else if (i == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimOrderHistoryPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimProfilePage()),
      );
    }
  }

  void _selectRecommended() {
    setState(() {
      showRecommendedOnly = true;
      _loadAiRecommendedMeals();
    });
  }

  void _selectAll() {
    setState(() {
      showRecommendedOnly = false;
      _loadAllMeals();
    });
  }

  String _localizedNutritionLine(
    BuildContext context, {
    required dynamic calories,
    required dynamic protein,
    required dynamic carbohydrates,
    required dynamic fat,
  }) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    final caloriesText = calories?.toString() ?? '0';
    final proteinText = protein?.toString() ?? '0';
    final carbsText = carbohydrates?.toString() ?? '0';
    final fatText = fat?.toString() ?? '0';

    if (isArabic) {
      return '$caloriesText سعرة حرارية • $proteinText جم بروتين • $carbsText جم كربوهيدرات • $fatText جم دهون';
    }

    return '$caloriesText kcal • ${proteinText}g protein • ${carbsText}g carbs • ${fatText}g fat';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: bg,
      appBar: const _PilgrimMealsAppBar(),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<Meal>>(
          future: _mealsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '${l10n.errorLoadingMeals}: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final visibleMeals = snapshot.data ?? <Meal>[];

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _MealsHeroCard(),
                  const SizedBox(height: 18),
                  _MealsSectionTitle(title: l10n.smartFilters),
                  const SizedBox(height: 10),
                  _MealFilterBar(
                    showRecommendedOnly: showRecommendedOnly,
                    onSelectRecommended: _selectRecommended,
                    onSelectAll: _selectAll,
                  ),
                  const SizedBox(height: 16),
                  _MealsSectionTitle(
                    title: showRecommendedOnly
                        ? l10n.aiRecommendedMeals
                        : l10n.allAvailableMeals,
                  ),
                  const SizedBox(height: 10),
                  if (visibleMeals.isEmpty)
                    _EmptyMealsState(
                      title: showRecommendedOnly
                          ? 'No suitable meals found'
                          : l10n.mealsAreNotCurrentlyAvailableForYourCampaign,
                      subtitle: showRecommendedOnly
                          ? 'Your health profile is complete, but the available meals do not match your health needs.'
                          : l10n.yourCampaignProviderHasNotAddedMealsYet,
                    )
                  else
                    ...visibleMeals.map((meal) {
                      final mealName = meal.localizedMealName(languageCode);
                      final mealType = meal.localizedMealType(languageCode);
                      final description = meal.localizedDescription(
                        languageCode,
                      );

                      final nutritionLine = _localizedNutritionLine(
                        context,
                        calories: meal.calories,
                        protein: meal.protein,
                        carbohydrates: meal.carbohydrates,
                        fat: meal.fat,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MealRequestCard(
                          title: mealName,
                          providerName: meal.providerName,
                          mealType: _localizedMealType(context, mealType),
                          description: description,
                          nutritionLine: nutritionLine,
                          isHealthMatched: meal.isHealthMatched,
                          icon: _getMealIcon(
                            meal.mealTypeEn.isNotEmpty
                                ? meal.mealTypeEn
                                : meal.mealType,
                          ),
                          imagePath: meal.image,
                          onSelectMeal: () {
                            _openSubmitMealRequestPage(
                              mealID: meal.mealID,
                              title: mealName,
                              description: description,
                              providerName: meal.providerName,
                              nutritionLine: nutritionLine,
                              icon: _getMealIcon(
                                meal.mealTypeEn.isNotEmpty
                                    ? meal.mealTypeEn
                                    : meal.mealType,
                              ),
                            );
                          },
                        ),
                      );
                    }),
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

class _PilgrimMealsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _PilgrimMealsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
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
            Text(
              l10n.meals,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        actions: const [SizedBox(width: 6)],
      ),
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
    final l10n = AppLocalizations.of(context)!;

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selectYourMeal,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.browseMealsReviewNutrition,
                        style: const TextStyle(
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
      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
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
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _FilterChipButton(
            label: l10n.aiRecommended,
            icon: Icons.auto_awesome_rounded,
            isSelected: showRecommendedOnly,
            onTap: onSelectRecommended,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FilterChipButton(
            label: l10n.allMeals,
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
            Icon(icon, size: 18, color: isSelected ? Colors.white : primary),
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
  final String imagePath;
  final VoidCallback onSelectMeal;

  const _MealRequestCard({
    required this.title,
    required this.providerName,
    required this.mealType,
    required this.description,
    required this.nutritionLine,
    required this.isHealthMatched,
    required this.icon,
    required this.imagePath,
    required this.onSelectMeal,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softBg = Color(0xFFEAF4F2);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [softBg, mint.withOpacity(0.35)],
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
                  Positioned.fill(
                    child: _MealImage(
                      imagePath: imagePath,
                      icon: icon,
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
                  '${l10n.providedBy} $providerName',
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
                    child: Text(
                      l10n.selectMeal,
                      style: const TextStyle(
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

class _MealImage extends StatelessWidget {
  final String imagePath;
  final IconData icon;

  const _MealImage({
    required this.imagePath,
    required this.icon,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softBg = Color(0xFFEAF4F2);
  static const Color mint = Color(0xFF9FE5C9);

  bool get _hasImage => imagePath.trim().isNotEmpty;

  String get _fixedImagePath {
    final path = imagePath.trim();

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // لو الباك إند يرجع المسار كذا: /uploads/name.jpg
    // اكتبي نفس رابط السيرفر المستخدم عندك في الخدمات.
    if (path.startsWith('/uploads/')) {
      return 'http://localhost:3000$path';
    }

    return path;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasImage) return _placeholder();

    return Image.network(
      _fixedImagePath,
      width: double.infinity,
      height: 150,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _placeholder();
      },
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [softBg, mint.withOpacity(0.35)],
        ),
      ),
      child: Center(
        child: Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black.withOpacity(0.04)),
          ),
          child: Icon(
            icon,
            size: 42,
            color: primary.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}

class _EmptyMealsState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyMealsState({required this.title, required this.subtitle});

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
            Icons.restaurant_menu_rounded,
            size: 36,
            color: primary.withOpacity(0.75),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
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
