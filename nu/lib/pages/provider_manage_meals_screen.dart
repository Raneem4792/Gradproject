import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../widgets/provider_bottom_nav.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import 'provider_home_screen.dart';
import '../session/user_session.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_dashboard_page.dart';

enum _FormMode { add, edit }

String _localizedMealType(BuildContext context, String type) {
  final l10n = AppLocalizations.of(context)!;

  switch (type) {
    case 'Healthy':
      return l10n.healthy;
    case 'Breakfast':
      return l10n.breakfast;
    case 'Lunch':
      return l10n.lunch;
    case 'Dinner':
      return l10n.dinner;
    case 'Vegetarian':
      return l10n.vegetarian;
    case 'High Protein':
      return l10n.highProtein;
    case 'Low Carb':
      return l10n.lowCarb;
    case 'Fast Food':
      return l10n.fastFood;
    default:
      return type;
  }
}

class ProviderMealManagementScreen extends StatefulWidget {
  const ProviderMealManagementScreen({super.key});
  static const routeName = '/provider-meal-management';

  @override
  State<ProviderMealManagementScreen> createState() =>
      _ProviderMealManagementScreenState();
}

class _ProviderMealManagementScreenState
    extends State<ProviderMealManagementScreen> {
  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFE8F6F1);
  static const Color gold = Color(0xFFF0E0C0);

  int _navIndex = 0;

  final MealService _mealService = MealService();
  List<Meal> _meals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMealsFromServer();
  }

  Future<void> _loadMealsFromServer() async {
    setState(() => _isLoading = true);
    try {
      final providerID = UserSession.userId;

      if (providerID == null || providerID.isEmpty) {
        throw Exception('Provider session not found');
      }

      final data = await _mealService.getMealsByProvider(providerID);
      if (!mounted) return;
      setState(() {
        _meals = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.error}: $e')));
    }
  }

  void _showMealDetails(Meal meal) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final mealName = meal.localizedMealName(languageCode);
    final mealType = meal.localizedMealType(languageCode);
    final description = meal.localizedDescription(languageCode);
    final canonicalMealType = meal.mealTypeEn.trim().isNotEmpty
        ? meal.mealTypeEn
        : meal.mealType;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 760),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: _MealImage(
                      imagePath: meal.image,
                      height: 190,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.mealDetails,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mealName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _detailChip(
                        _localizedMealType(context, canonicalMealType),
                        filled: true,
                      ),
                      _detailChip('${meal.calories} ${l10n.kcal}'),
                      _detailChip('${meal.protein} ${l10n.gramsProtein}'),
                      _detailChip('${meal.carbohydrates} ${l10n.gramsCarbs}'),
                      _detailChip('${meal.fat} ${l10n.gramsFat}'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _detailRow(l10n.mealName, mealName),
                  _detailRow(
                    l10n.mealType,
                    _localizedMealType(context, canonicalMealType),
                  ),
                  _detailRow(l10n.description, description),
                  _detailRow(l10n.calories, '${meal.calories} ${l10n.kcal}'),
                  _detailRow(l10n.protein, '${meal.protein} g'),
                  _detailRow(l10n.carbohydrates, '${meal.carbohydrates} g'),
                  _detailRow(l10n.fat, '${meal.fat} g'),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primary,
                            side: BorderSide(color: primary.withOpacity(0.22)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: Text(
                            l10n.close,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _openForm(_FormMode.edit, meal);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: Text(
                            l10n.edit,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    } else if (i == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IncomingMealRequestsPage()),
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

  Widget _detailChip(String text, {bool filled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? softMint : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withOpacity(0.12)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: primaryDark,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _openForm(_FormMode mode, Meal? meal) async {
    final success = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _MealFormSheet(mode: mode, initial: meal),
    );
    if (success == true) _loadMealsFromServer();
  }

  Future<void> _deleteMeal(Meal meal) async {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final mealName = meal.localizedMealName(languageCode);

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          l10n.deleteMealQuestion,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text(
          l10n.areYouSureDeleteMeal(mealName),
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: primary.withOpacity(0.85),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB3261E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.delete,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );

    if (ok == true) {
      await _mealService.deleteMeal(meal.mealID);
      _loadMealsFromServer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        surfaceTintColor: Colors.white,
        titleSpacing: 4,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
              ),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,
                size: 20,
              ),
            ),
            const SizedBox(width: 2),
            const Text(
              'NUSUQ',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
                fontSize: 17,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        actions: const [SizedBox(width: 6)],
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 14),
                    _buildAddButton(),
                    const SizedBox(height: 16),
                    ListView.separated(
                      itemCount: _meals.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, i) => _MealCard(
                        meal: _meals[i],
                        onTap: () => _showMealDetails(_meals[i]),
                        onEdit: () => _openForm(_FormMode.edit, _meals[i]),
                        onDelete: () => _deleteMeal(_meals[i]),
                      ),
                    ),
                    if (_meals.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: Center(
                          child: Text(
                            l10n.noMealsAddedYet,
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

  Widget _buildHeaderCard() {
    final l10n = AppLocalizations.of(context)!;

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
              Icons.restaurant_menu_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.manageMeals,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
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
              '${_meals.length} ${l10n.meals}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 11.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openForm(_FormMode.add, null),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.addMeal,
                style: TextStyle(
                  color: primary.withOpacity(0.92),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: softMint,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: mint.withOpacity(0.60)),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: primary.withOpacity(0.90),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MealCard({
    required this.meal,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final mealName = meal.localizedMealName(languageCode);
    final mealType = meal.localizedMealType(languageCode);
    final description = meal.localizedDescription(languageCode);
    final canonicalMealType = meal.mealTypeEn.trim().isNotEmpty
        ? meal.mealTypeEn
        : meal.mealType;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 138,
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
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: softMint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: mint.withOpacity(0.55)),
                ),
                clipBehavior: Clip.antiAlias,
                child: _MealImage(imagePath: meal.image, width: 62, height: 62),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MealPill(
                          text: _localizedMealType(context, canonicalMealType),
                          filled: true,
                        ),
                        _MealPill(text: '${meal.calories} ${l10n.kcal}'),
                        _MealPill(text: '${meal.protein}${l10n.gramsProtein}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.description_outlined,
                      text: description,
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.bar_chart_rounded,
                      text:
                          '${meal.carbohydrates}${l10n.gramsCarbs} • ${meal.fat}${l10n.gramsFat}',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onEdit,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: primary.withOpacity(0.20),
                              ),
                              foregroundColor: primary,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            label: Text(
                              l10n.edit,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onDelete,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFFFF1F0),
                              foregroundColor: const Color(0xFFB3261E),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                            ),
                            label: Text(
                              l10n.delete,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
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
        ),
      ),
    );
  }
}

class _MealPill extends StatelessWidget {
  final String text;
  final bool filled;

  const _MealPill({required this.text, this.filled = false});

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: filled ? softMint : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withOpacity(0.12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          color: primary.withOpacity(0.88),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: primary.withOpacity(0.80)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.6,
              color: Colors.black.withOpacity(0.68),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _MealImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const _MealImage({
    required this.imagePath,
    required this.width,
    required this.height,
  });

  bool get _isNetworkImage {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  bool get _isLocalFile {
    return imagePath.startsWith('/') || imagePath.startsWith('file://');
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _placeholder();
    }

    if (_isNetworkImage) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    if (!kIsWeb && _isLocalFile) {
      final path = imagePath.replaceFirst('file://', '');
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE6F6F0),
      child: const Icon(Icons.restaurant, color: Color(0xFF0B4A40)),
    );
  }
}

class _MealFormSheet extends StatefulWidget {
  final _FormMode mode;
  final Meal? initial;

  const _MealFormSheet({required this.mode, this.initial});

  @override
  State<_MealFormSheet> createState() => _MealFormSheetState();
}

class _MealFormSheetState extends State<_MealFormSheet> {
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  static const List<String> _mealTypes = [
    'Healthy',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Vegetarian',
    'High Protein',
    'Low Carb',
    'Fast Food',
  ];

  final _service = MealService();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameAr;
  late TextEditingController _nameEn;
  late TextEditingController _descAr;
  late TextEditingController _descEn;
  late TextEditingController _cal;
  late TextEditingController _pro;
  late TextEditingController _carb;
  late TextEditingController _fat;

  late String _selectedMealType;
  XFile? _selectedImage;
  String _existingImage = '';
  bool _isSaving = false;

  bool get _isEdit => widget.mode == _FormMode.edit;

  @override
  void initState() {
    super.initState();
    _nameAr = TextEditingController(text: widget.initial?.mealNameAr ?? '');
    _nameEn = TextEditingController(text: widget.initial?.mealNameEn ?? '');
    _descAr = TextEditingController(text: widget.initial?.descriptionAr ?? '');
    _descEn = TextEditingController(text: widget.initial?.descriptionEn ?? '');
    _cal = TextEditingController(
      text: widget.initial?.calories.toString() ?? '',
    );
    _pro = TextEditingController(
      text: widget.initial?.protein.toString() ?? '',
    );
    _carb = TextEditingController(
      text: widget.initial?.carbohydrates.toString() ?? '',
    );
    _fat = TextEditingController(text: widget.initial?.fat.toString() ?? '');
    final initialType = widget.initial?.mealTypeEn.trim().isNotEmpty == true
        ? widget.initial!.mealTypeEn
        : widget.initial?.mealType ?? '';
    _selectedMealType = _mealTypes.contains(initialType)
        ? initialType
        : (initialType.isNotEmpty ? initialType : 'Healthy');
    _existingImage = widget.initial?.image ?? '';
  }

  @override
  void dispose() {
    _nameAr.dispose();
    _nameEn.dispose();
    _descAr.dispose();
    _descEn.dispose();
    _cal.dispose();
    _pro.dispose();
    _carb.dispose();
    _fat.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  String? _requiredText(String? value, String fieldName) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.fieldIsRequired(fieldName);
    }
    return null;
  }

  String? _mealNameValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;

    final basic = _requiredText(value, l10n.mealName);
    if (basic != null) return basic;

    final trimmed = value!.trim();
    final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(trimmed);
    final hasEnglish = RegExp(r'[A-Za-z]').hasMatch(trimmed);
    final hasDigits = RegExp(r'\d').hasMatch(trimmed);
    final hasSymbols = RegExp(r'[^A-Za-z\u0600-\u06FF\s]').hasMatch(trimmed);

    if (hasDigits) {
      return l10n.mealNameMustNotContainNumbers;
    }

    if (hasSymbols) {
      return l10n.mealNameMustNotContainSymbols;
    }

    if (hasArabic && hasEnglish) {
      return l10n.mealNameMustBeArabicOrEnglishOnly;
    }

    return null;
  }

  String? _descriptionValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;

    final basic = _requiredText(value, l10n.description);
    if (basic != null) return basic;

    final trimmed = value!.trim();
    final hasSymbols = RegExp(r'[^A-Za-z\u0600-\u06FF0-9\s]').hasMatch(trimmed);

    if (hasSymbols) {
      return l10n.descriptionMustNotContainSymbols;
    }

    return null;
  }

  String? _requiredNumber(String? value, String fieldName) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.fieldIsRequired(fieldName);
    }
    if (num.tryParse(value.trim()) == null) {
      return l10n.fieldMustBeValidNumber(fieldName);
    }
    return null;
  }

  Widget _sectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13.2,
        fontWeight: FontWeight.w800,
        color: primaryDark,
      ),
    );
  }

  Widget _styledInput(
    TextEditingController ctrl,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.38),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: primary.withOpacity(0.78)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary.withOpacity(0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFB3261E)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFB3261E), width: 1.2),
        ),
      ),
    );
  }

  Widget _imagePreview() {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedImage != null) {
      if (kIsWeb) {
        return FutureBuilder<List<int>>(
          future: _selectedImage!.readAsBytes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.memory(
                Uint8List.fromList(snapshot.data!),
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.file(
          File(_selectedImage!.path),
          height: 170,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_existingImage.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _MealImage(
          imagePath: _existingImage,
          height: 170,
          width: double.infinity,
        ),
      );
    }

    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: softMint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mint.withOpacity(0.55)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_outlined, size: 42, color: primary),
          const SizedBox(height: 8),
          Text(
            l10n.noImageSelected,
            style: const TextStyle(
              color: primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    final currentProviderId = UserSession.userId;
    final currentProviderName = UserSession.fullName;

    if (currentProviderId == null || currentProviderId.isEmpty) {
      _showSnack(l10n.providerSessionNotFound, const Color(0xFFB3261E));
      return;
    }

    setState(() => _isSaving = true);

    final mealTypeAr = _localizedMealType(context, _selectedMealType);

    final meal = Meal(
      mealID: widget.initial?.mealID ?? 0,
      mealName: _nameEn.text.trim().isNotEmpty
          ? _nameEn.text.trim()
          : _nameAr.text.trim(),
      mealNameEn: _nameEn.text.trim(),
      mealNameAr: _nameAr.text.trim(),
      mealType: _selectedMealType,
      mealTypeEn: _selectedMealType,
      mealTypeAr: mealTypeAr,
      description: _descEn.text.trim().isNotEmpty
          ? _descEn.text.trim()
          : _descAr.text.trim(),
      descriptionEn: _descEn.text.trim(),
      descriptionAr: _descAr.text.trim(),
      protein: num.parse(_pro.text.trim()),
      carbohydrates: num.parse(_carb.text.trim()),
      fat: num.parse(_fat.text.trim()),
      calories: int.parse(_cal.text.trim()),
      image: _existingImage,
      providerID: widget.initial?.providerID ?? currentProviderId,
      providerName: widget.initial?.providerName ?? currentProviderName ?? '',
    );

    try {
      if (widget.mode == _FormMode.add) {
        await _service.addMeal(meal, imageFile: _selectedImage);
        _showSnack(l10n.mealAddedSuccessfully, primary);
      } else {
        await _service.updateMeal(meal.mealID, meal, imageFile: _selectedImage);
        _showSnack(l10n.mealUpdatedSuccessfully, primary);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showSnack('${l10n.operationFailed}: $e', const Color(0xFFB3261E));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _isEdit ? l10n.editMeal : l10n.addNewMeal,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isEdit
                    ? l10n.updateMealDetailsBelow
                    : l10n.enterMealInformationBelow,
                style: TextStyle(
                  fontSize: 13.3,
                  height: 1.35,
                  color: Colors.black.withOpacity(0.62),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              _imagePreview(),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primary,
                    side: BorderSide(color: primary.withOpacity(0.22)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.upload_file_rounded),
                  label: Text(
                    l10n.chooseImageFromDevice,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _sectionLabel('Meal Name - Arabic'),
              const SizedBox(height: 8),
              _styledInput(
                _nameAr,
                'اسم الوجبة بالعربي',
                validator: _mealNameValidator,
                prefixIcon: Icons.restaurant_menu_rounded,
              ),
              const SizedBox(height: 14),
              _sectionLabel('Meal Name - English'),
              const SizedBox(height: 8),
              _styledInput(
                _nameEn,
                'Meal name in English',
                validator: _mealNameValidator,
                prefixIcon: Icons.restaurant_menu_rounded,
              ),
              const SizedBox(height: 14),
              _sectionLabel(l10n.mealType),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedMealType,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                items: _mealTypes
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          _localizedMealType(context, type),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedMealType = value);
                },
                decoration: InputDecoration(
                  hintText: l10n.selectMealType,
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: primary.withOpacity(0.78),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primary.withOpacity(0.10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: primary, width: 1.3),
                  ),
                ),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                borderRadius: BorderRadius.circular(18),
              ),
              const SizedBox(height: 14),
              _sectionLabel('Description - Arabic'),
              const SizedBox(height: 8),
              _styledInput(
                _descAr,
                'وصف الوجبة بالعربي',
                maxLines: 4,
                validator: _descriptionValidator,
                prefixIcon: Icons.description_outlined,
              ),
              const SizedBox(height: 14),
              _sectionLabel('Description - English'),
              const SizedBox(height: 8),
              _styledInput(
                _descEn,
                'Meal description in English',
                maxLines: 4,
                validator: _descriptionValidator,
                prefixIcon: Icons.description_outlined,
              ),
              const SizedBox(height: 14),
              _sectionLabel(l10n.nutritionInformation),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _styledInput(
                      _cal,
                      l10n.calories,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => _requiredNumber(v, l10n.calories),
                      prefixIcon: Icons.local_fire_department_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _styledInput(
                      _pro,
                      l10n.protein,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      validator: (v) => _requiredNumber(v, l10n.protein),
                      prefixIcon: Icons.fitness_center_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _styledInput(
                      _carb,
                      l10n.carbohydrates,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      validator: (v) => _requiredNumber(v, l10n.carbohydrates),
                      prefixIcon: Icons.grain_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _styledInput(
                      _fat,
                      l10n.fat,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      validator: (v) => _requiredNumber(v, l10n.fat),
                      prefixIcon: Icons.opacity_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: primary.withOpacity(0.22)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isEdit ? l10n.saveChanges : l10n.addMeal,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
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
