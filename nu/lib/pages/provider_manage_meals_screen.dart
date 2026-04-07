import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/provider_bottom_nav.dart';
import '../models/meal.dart'; 
import '../services/meal_service.dart';
import 'provider_home_screen.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_dashboard_page.dart';

enum _FormMode { add, edit }

class ProviderMealManagementScreen extends StatefulWidget {
  const ProviderMealManagementScreen({super.key});
  static const routeName = '/provider-meal-management';

  @override
  State<ProviderMealManagementScreen> createState() =>
      _ProviderMealManagementScreenState();
}

class _ProviderMealManagementScreenState extends State<ProviderMealManagementScreen> {
  // الألوان الخاصة بهوية تطبيقك (نفس اللي كانت عندك)
  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

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
      final data = await _mealService.getMeals();
      setState(() {
        _meals = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        title: const Text("NUSUQ - Manage Meals", 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 17)),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildAddButton(),
                  const SizedBox(height: 16),
                  ListView.separated(
                    itemCount: _meals.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, i) => _MealCard(
                      meal: _meals[i],
                      onEdit: () => _openForm(_FormMode.edit, _meals[i]),
                      onDelete: () => _deleteMeal(_meals[i]),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: ProviderBottomNav(currentIndex: 0, onTap: (i) {}),
    );
  }

  // --- Widgets التنسيق الجمالي ---

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primaryDark, primary, primaryMid]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: primary.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Manage Meals", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: mint.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text("${_meals.length} meals", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () => _openForm(_FormMode.add, null),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: primary.withOpacity(0.1)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add Meal", style: TextStyle(color: primary, fontWeight: FontWeight.w900)),
            SizedBox(width: 10),
            Icon(Icons.add_circle, color: primary),
          ],
        ),
      ),
    );
  }

  void _openForm(_FormMode mode, Meal? meal) async {
    final success = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) => _MealFormSheet(mode: mode, initial: meal),
    );
    if (success == true) _loadMealsFromServer();
  }

  Future<void> _deleteMeal(Meal meal) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Delete")),
        ],
      ),
    );
    if (ok == true) {
      await _mealService.deleteMeal(meal.mealID);
      _loadMealsFromServer();
    }
  }
}

// --- كرت الوجبة المنسق ---
class _MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onEdit, onDelete;
  const _MealCard({required this.meal, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: Row(
        children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: const Color(0xFFE6F6F0), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.restaurant, color: Color(0xFF0B4A40))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meal.mealName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              Text(meal.nutritionLine, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ])),
          IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: onDelete),
        ],
      ),
    );
  }
}

// --- الفورم المنسق ---
class _MealFormSheet extends StatefulWidget {
  final _FormMode mode;
  final Meal? initial;
  const _MealFormSheet({required this.mode, this.initial});

  @override
  State<_MealFormSheet> createState() => _MealFormSheetState();
}

class _MealFormSheetState extends State<_MealFormSheet> {
  final _service = MealService();
  late TextEditingController _name, _desc, _type, _cal, _pro, _carb, _fat, _img;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial?.mealName ?? "");
    _desc = TextEditingController(text: widget.initial?.description ?? "");
    _type = TextEditingController(text: widget.initial?.mealType ?? "Healthy");
    _cal = TextEditingController(text: widget.initial?.calories.toString() ?? "0");
    _pro = TextEditingController(text: widget.initial?.protein.toString() ?? "0");
    _carb = TextEditingController(text: widget.initial?.carbohydrates.toString() ?? "0");
    _fat = TextEditingController(text: widget.initial?.fat.toString() ?? "0");
    _img = TextEditingController(text: widget.initial?.image ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Meal Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B4A40))),
            const SizedBox(height: 20),
            _input(_name, "Meal Name"),
            _input(_desc, "Description"),
            Row(children: [
              Expanded(child: _input(_cal, "Calories", isNum: true)),
              const SizedBox(width: 10),
              Expanded(child: _input(_pro, "Protein", isNum: true)),
            ]),
            _input(_img, "Image URL"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B4A40), minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Confirm", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String hint, {bool isNum = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }

  Future<void> _save() async {
  // 1. التأكد من أن الاسم والوصف ليسوا فارغين
  if (_name.text.isEmpty || _desc.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill Meal Name and Description")),
    );
    return;
  }

  final meal = Meal(
    mealID: widget.initial?.mealID ?? 0,
    mealName: _name.text,
    mealType: _type.text.isEmpty ? "Healthy" : _type.text, // قيمة افتراضية
    description: _desc.text,
    // التأكد من إرسال أرقام صالحة (حتى لو كانت 0)
    protein: num.tryParse(_pro.text) ?? 10.0, 
    carbohydrates: num.tryParse(_carb.text) ?? 20.0,
    fat: num.tryParse(_fat.text) ?? 5.0,
    calories: int.tryParse(_cal.text) ?? 100,
    // إذا كانت الصورة فارغة نرسل رابط افتراضي عشان ما يفشل الـ SQL
    image: _img.text.isEmpty ? "https://cdn-icons-png.flaticon.com/512/706/706164.png" : _img.text,
    providerID: widget.initial?.providerID ?? "PROV001", 
    providerName: widget.initial?.providerName ?? "Main Provider",
  );

  try {
    if (widget.mode == _FormMode.add) {
      await _service.addMeal(meal);
      _showSnack("Meal added successfully!", Colors.green);
    } else {
      await _service.updateMeal(meal.mealID, meal);
      _showSnack("Meal updated successfully!", Colors.blue);
    }
    Navigator.pop(context, true);
  } catch (e) {
    // 👈 هذا السطر سيطبع لكِ الخطأ الحقيقي في الـ Debug Console
    print("Error during Add/Update: $e"); 
    _showSnack("Operation failed: $e", Colors.red);
  }
}

void _showSnack(String msg, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: color),
  );
}
}