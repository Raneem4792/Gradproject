import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProviderMealManagementScreen extends StatefulWidget {
  const ProviderMealManagementScreen({super.key});
  static const routeName = '/provider-meal-management';

  @override
  State<ProviderMealManagementScreen> createState() =>
      _ProviderMealManagementScreenState();
}

class _ProviderMealManagementScreenState
    extends State<ProviderMealManagementScreen> {
  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  final List<_MealItem> _meals = [
    const _MealItem(
      id: 'MEAL-001',
      name: 'Chicken Kabsa',
      description: 'Rice, chicken, kabsa spices, salad.',
      type: _MealType.lunch,
      calories: 650,
      proteinG: 35,
      carbsG: 78,
      fatG: 22,
      tags: {_DietTag.lowSugar},
      imagePath: null,
    ),
    const _MealItem(
      id: 'MEAL-002',
      name: 'Cheese Omelette Box',
      description: 'Eggs, cheese, herbs, bread.',
      type: _MealType.breakfast,
      calories: 420,
      proteinG: 20,
      carbsG: 18,
      fatG: 28,
      tags: {_DietTag.diabeticFriendly},
      imagePath: null,
    ),
    const _MealItem(
      id: 'MEAL-003',
      name: 'Fish Rice Meal',
      description: 'Fish, rice, lemon sauce, vegetables.',
      type: _MealType.dinner,
      calories: 520,
      proteinG: 34,
      carbsG: 55,
      fatG: 16,
      tags: {_DietTag.lowSalt, _DietTag.hypertensionFriendly},
      imagePath: null,
    ),
  ];

  int _navIndex = 1;

  void _openAddSheet() async {
    final created = await showModalBottomSheet<_MealItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => const _MealFormSheet(mode: _FormMode.add),
    );

    if (created == null) return;

    setState(() {
      _meals.insert(0, created.copyWith(id: _generateId()));
    });
  }

  void _openEditSheet(_MealItem meal) async {
    final updated = await showModalBottomSheet<_MealItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => _MealFormSheet(mode: _FormMode.edit, initial: meal),
    );

    if (updated == null) return;

    setState(() {
      final idx = _meals.indexWhere((m) => m.id == meal.id);
      if (idx != -1) _meals[idx] = updated.copyWith(id: meal.id);
    });
  }

  Future<void> _deleteMeal(_MealItem meal) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Delete meal?',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text(
          'Are you sure you want to delete "${meal.name}"?',
          style: TextStyle(
            color: Colors.black.withOpacity(0.66),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
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
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );

    if (ok != true) return;
    setState(() => _meals.removeWhere((m) => m.id == meal.id));
  }

  String _generateId() {
    final n = _meals.length + 1;
    return 'MEAL-${n.toString().padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _MealManagementMainAppBar(onBack: () => Navigator.pop(context)),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MealManagementHeaderCard(
                title: "Manage Meals",
                badgeText: "${_meals.length} meals",
              ),
              const SizedBox(height: 14),
              _AddMealWideButton(onTap: _openAddSheet),
              const SizedBox(height: 16),
              ListView.separated(
                itemCount: _meals.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final meal = _meals[i];
                  return _MealCard(
                    meal: meal,
                    onEdit: () => _openEditSheet(meal),
                    onDelete: () => _deleteMeal(meal),
                  );
                },
              ),
              if (_meals.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Center(
                    child: Text(
                      "No meals added yet",
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
      bottomNavigationBar: _ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _MealManagementMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _MealManagementMainAppBar({required this.onBack});

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

class _MealManagementHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;

  const _MealManagementHeaderCard({
    required this.title,
    required this.badgeText,
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
            child: const Icon(
              Icons.restaurant_menu_rounded,
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

class _AddMealWideButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMealWideButton({required this.onTap});

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                "Add Meal",
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
  const _MealCard({
    required this.meal,
    required this.onEdit,
    required this.onDelete,
  });

  final _MealItem meal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    final tagsText = _dietTagsToShortText(meal.tags);

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 150,
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
          if (meal.imagePath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(meal.imagePath!),
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 18),
          ] else ...[
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: softMint,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: mint.withOpacity(0.55)),
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                color: primary.withOpacity(0.80),
                size: 36,
              ),
            ),
            const SizedBox(width: 18),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: primaryDark,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _MealIdPill(id: meal.id),
                    const SizedBox(width: 8),
                    _TypePill(type: meal.type),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.local_offer_outlined,
                  text: tagsText.isEmpty ? 'No tags' : tagsText,
                ),
                const SizedBox(height: 6),
                _InfoRow(icon: Icons.notes_rounded, text: meal.description),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primary.withOpacity(0.20)),
                          foregroundColor: primary,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: const Text(
                          'Edit',
                          style: TextStyle(fontWeight: FontWeight.w900),
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
                        label: const Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.w900),
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

  static String _dietTagsToShortText(Set<_DietTag> tags) {
    if (tags.isEmpty) return '';
    final map = <_DietTag, String>{
      _DietTag.diabeticFriendly: 'Diabetes',
      _DietTag.hypertensionFriendly: 'Pressure',
      _DietTag.lowSalt: 'Low Salt',
      _DietTag.lowSugar: 'Low Sugar',
      _DietTag.glutenFree: 'Gluten Free',
      _DietTag.vegetarian: 'Veg',
    };
    final list = tags
        .map((t) => map[t] ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    return list.take(2).join(' • ');
  }
}

class _MealIdPill extends StatelessWidget {
  final String id;

  const _MealIdPill({required this.id});

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: softMint,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withOpacity(0.12)),
      ),
      child: Text(
        id,
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

class _TypePill extends StatelessWidget {
  const _TypePill({required this.type});
  final _MealType type;

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    final text = switch (type) {
      _MealType.breakfast => 'Breakfast',
      _MealType.lunch => 'Lunch',
      _MealType.dinner => 'Dinner',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
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

enum _FormMode { add, edit }

class _MealFormSheet extends StatefulWidget {
  const _MealFormSheet({required this.mode, this.initial});

  final _FormMode mode;
  final _MealItem? initial;

  @override
  State<_MealFormSheet> createState() => _MealFormSheetState();
}

class _MealFormSheetState extends State<_MealFormSheet> {
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  late final TextEditingController nameCtrl;
  late final TextEditingController descCtrl;

  _MealType type = _MealType.lunch;

  int calories = 500;
  int proteinG = 20;
  int carbsG = 60;
  int fatG = 15;

  late Set<_DietTag> tags;

  final ImagePicker _picker = ImagePicker();
  String? imagePath;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    descCtrl = TextEditingController(text: widget.initial?.description ?? '');

    type = widget.initial?.type ?? _MealType.lunch;

    calories = widget.initial?.calories ?? 500;
    proteinG = widget.initial?.proteinG ?? 20;
    carbsG = widget.initial?.carbsG ?? 60;
    fatG = widget.initial?.fatG ?? 15;

    tags = Set<_DietTag>.from(widget.initial?.tags ?? <_DietTag>{});
    imagePath = widget.initial?.imagePath;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  bool get _valid =>
      nameCtrl.text.trim().isNotEmpty && descCtrl.text.trim().isNotEmpty;

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => imagePath = picked.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  void _removeImage() => setState(() => imagePath = null);

  void _save() {
    if (!_valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill Meal Name and Ingredients')),
      );
      return;
    }

    final meal = _MealItem(
      id: widget.initial?.id ?? 'TEMP',
      name: nameCtrl.text.trim(),
      description: descCtrl.text.trim(),
      type: type,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      tags: tags,
      imagePath: imagePath,
    );

    Navigator.pop(context, meal);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        child: SingleChildScrollView(
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
                widget.mode == _FormMode.add ? 'Add Meal' : 'Edit Meal',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 14),

              const _FieldLabel('Meal Name'),
              const SizedBox(height: 8),
              _TextFieldBox(controller: nameCtrl, hint: 'Enter meal name'),

              const SizedBox(height: 14),

              const _FieldLabel('Ingredients / Description'),
              const SizedBox(height: 8),
              _TextFieldBox(
                controller: descCtrl,
                hint: 'Ingredients, components, notes...',
                maxLines: 4,
              ),

              const SizedBox(height: 14),

              const _FieldLabel('Meal Type'),
              const SizedBox(height: 8),
              _TypeSelector(
                value: type,
                onChanged: (v) => setState(() => type = v),
              ),

              const SizedBox(height: 14),

              const _FieldLabel('Nutritional information'),
              const SizedBox(height: 8),
              _NutritionPanel(
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                onCaloriesChanged: (v) => setState(() => calories = v),
                onProteinChanged: (v) => setState(() => proteinG = v),
                onCarbsChanged: (v) => setState(() => carbsG = v),
                onFatChanged: (v) => setState(() => fatG = v),
              ),

              const SizedBox(height: 14),

              const _FieldLabel('Suitable for'),
              const SizedBox(height: 8),
              _DietChecklist(
                value: tags,
                onChanged: (next) => setState(() => tags = next),
              ),

              const SizedBox(height: 14),

              const _FieldLabel('Image (optional)'),
              const SizedBox(height: 8),
              _ImagePickerBox(
                imagePath: imagePath,
                onPick: _pickImage,
                onRemove: imagePath == null ? null : _removeImage,
              ),

              const SizedBox(height: 16),

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
                        'Cancel',
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
                          colors: [primaryDark, primary, primaryMid],
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
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          widget.mode == _FormMode.add ? 'Add' : 'Save',
                          style: const TextStyle(
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        color: Color(0xFF052720),
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary.withOpacity(0.10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary.withOpacity(0.10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: primary, width: 1.2),
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.value, required this.onChanged});
  final _MealType value;
  final ValueChanged<_MealType> onChanged;

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    Widget chip(String text, _MealType t) {
      final selected = value == t;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(t),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryDark, primary, Color(0xFF167062)],
                    )
                  : null,
              color: selected ? null : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? Colors.transparent
                    : primary.withOpacity(0.10),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip('Breakfast', _MealType.breakfast),
        const SizedBox(width: 10),
        chip('Lunch', _MealType.lunch),
        const SizedBox(width: 10),
        chip('Dinner', _MealType.dinner),
      ],
    );
  }
}

class _NutritionPanel extends StatelessWidget {
  const _NutritionPanel({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.onCaloriesChanged,
    required this.onProteinChanged,
    required this.onCarbsChanged,
    required this.onFatChanged,
  });

  final int calories, proteinG, carbsG, fatG;
  final ValueChanged<int> onCaloriesChanged;
  final ValueChanged<int> onProteinChanged;
  final ValueChanged<int> onCarbsChanged;
  final ValueChanged<int> onFatChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _NutritionCard(
                label: 'Calories',
                value: calories,
                suffix: 'kcal',
                onMinus: () =>
                    onCaloriesChanged((calories - 10).clamp(0, 3000)),
                onPlus: () => onCaloriesChanged((calories + 10).clamp(0, 3000)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _NutritionCard(
                label: 'Protein',
                value: proteinG,
                suffix: 'g',
                onMinus: () => onProteinChanged((proteinG - 1).clamp(0, 300)),
                onPlus: () => onProteinChanged((proteinG + 1).clamp(0, 300)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _NutritionCard(
                label: 'Carbs',
                value: carbsG,
                suffix: 'g',
                onMinus: () => onCarbsChanged((carbsG - 1).clamp(0, 400)),
                onPlus: () => onCarbsChanged((carbsG + 1).clamp(0, 400)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _NutritionCard(
                label: 'Fat',
                value: fatG,
                suffix: 'g',
                onMinus: () => onFatChanged((fatG - 1).clamp(0, 200)),
                onPlus: () => onFatChanged((fatG + 1).clamp(0, 200)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({
    required this.label,
    required this.value,
    required this.suffix,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final int value;
  final String suffix;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: primary.withOpacity(0.04),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$value $suffix',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: primary.withOpacity(0.90),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MiniIconButton(icon: Icons.remove, onTap: onMinus),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniIconButton(icon: Icons.add, onTap: onPlus),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DietChecklist extends StatelessWidget {
  const _DietChecklist({required this.value, required this.onChanged});

  final Set<_DietTag> value;
  final ValueChanged<Set<_DietTag>> onChanged;

  static const Color primary = Color(0xFF0B4A40);

  String _label(_DietTag t) {
    switch (t) {
      case _DietTag.diabeticFriendly:
        return 'Diabetes';
      case _DietTag.hypertensionFriendly:
        return 'Blood Pressure';
      case _DietTag.lowSalt:
        return 'Low Salt';
      case _DietTag.lowSugar:
        return 'Low Sugar';
      case _DietTag.glutenFree:
        return 'Gluten Free';
      case _DietTag.vegetarian:
        return 'Vegetarian';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _DietTag.values.map((tag) {
        final selected = value.contains(tag);

        return InkWell(
          onTap: () {
            final next = Set<_DietTag>.from(value);
            if (selected) {
              next.remove(tag);
            } else {
              next.add(tag);
            }
            onChanged(next);
          },
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? primary : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: selected ? primary : primary.withOpacity(0.10),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  color: primary.withOpacity(0.04),
                ),
              ],
            ),
            child: Text(
              _label(tag),
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: softMint,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mint.withOpacity(0.70)),
        ),
        child: Icon(icon, size: 18, color: primary),
      ),
    );
  }
}

class _ImagePickerBox extends StatelessWidget {
  const _ImagePickerBox({
    required this.imagePath,
    required this.onPick,
    required this.onRemove,
  });

  final String? imagePath;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hasImage ? 'Image selected' : 'No image selected',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: hasImage ? Colors.black87 : Colors.black45,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: onPick,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: softMint,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: mint.withOpacity(0.70)),
                  ),
                  child: Text(
                    'Pick',
                    style: TextStyle(
                      color: primary.withOpacity(0.90),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              if (onRemove != null) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFD5D2)),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Color(0xFFB3261E),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (hasImage) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(imagePath!),
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

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

enum _MealType { breakfast, lunch, dinner }

enum _DietTag {
  diabeticFriendly,
  hypertensionFriendly,
  lowSalt,
  lowSugar,
  glutenFree,
  vegetarian,
}

class _MealItem {
  final String id;
  final String name;
  final String description;
  final _MealType type;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final Set<_DietTag> tags;
  final String? imagePath;

  const _MealItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.tags,
    required this.imagePath,
  });

  _MealItem copyWith({
    String? id,
    String? name,
    String? description,
    _MealType? type,
    int? calories,
    int? proteinG,
    int? carbsG,
    int? fatG,
    Set<_DietTag>? tags,
    String? imagePath,
  }) {
    return _MealItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      tags: tags ?? this.tags,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
