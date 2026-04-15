import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/provider_bottom_nav.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import 'provider_home_screen.dart';

enum _FormMode { add, edit }

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _showMealDetails(Meal meal) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _MealImage(
                    imagePath: meal.image,
                    height: 180,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  meal.mealName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                _detailChip(meal.mealType),
                const SizedBox(height: 16),
                _detailRow("Description", meal.description),
                _detailRow("Calories", "${meal.calories} kcal"),
                _detailRow("Protein", "${meal.protein} g"),
                _detailRow("Carbohydrates", "${meal.carbohydrates} g"),
                _detailRow("Fat", "${meal.fat} g"),
                _detailRow("Provider", meal.providerName),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
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
                          backgroundColor: primary,
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.white),
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
    );
  }

  Widget _detailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: mint.withOpacity(0.25),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: primaryDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
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
        content: Text("Are you sure you want to delete ${meal.mealName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
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
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.6,
        leading: IconButton(
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
        title: const Text(
          "NUSUQ",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
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
                      onTap: () => _showMealDetails(_meals[i]),
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

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryDark, primary, primaryMid],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Manage Meals",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: mint.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${_meals.length} meals",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () => _openForm(_FormMode.add, null),
      borderRadius: BorderRadius.circular(18),
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
            Text(
              "Add Meal",
              style: TextStyle(color: primary, fontWeight: FontWeight.w900),
            ),
            SizedBox(width: 10),
            Icon(Icons.add_circle, color: primary),
          ],
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _MealImage(
                imagePath: meal.image,
                width: 64,
                height: 64,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.mealName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.nutritionLine,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
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
    return imagePath.startsWith('http://') ||
        imagePath.startsWith('https://');
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
  static const Color primary = Color(0xFF0B4A40);
  static const Color mintBg = Color(0xFFE6F6F0);

  final _service = MealService();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _name;
  late TextEditingController _desc;
  late TextEditingController _type;
  late TextEditingController _cal;
  late TextEditingController _pro;
  late TextEditingController _carb;
  late TextEditingController _fat;

  XFile? _selectedImage;
  String _existingImage = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial?.mealName ?? "");
    _desc = TextEditingController(text: widget.initial?.description ?? "");
    _type = TextEditingController(text: widget.initial?.mealType ?? "Healthy");
    _cal = TextEditingController(
      text: widget.initial?.calories.toString() ?? "",
    );
    _pro = TextEditingController(
      text: widget.initial?.protein.toString() ?? "",
    );
    _carb = TextEditingController(
      text: widget.initial?.carbohydrates.toString() ?? "",
    );
    _fat = TextEditingController(
      text: widget.initial?.fat.toString() ?? "",
    );
    _existingImage = widget.initial?.image ?? '';
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
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _requiredNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (num.tryParse(value.trim()) == null) {
      return '$fieldName must be a valid number';
    }
    return null;
  }

  Widget _input(
    TextEditingController ctrl,
    String hint, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _imagePreview() {
    if (_selectedImage != null) {
      if (kIsWeb) {
        return FutureBuilder<List<int>>(
          future: _selectedImage!.readAsBytes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                Uint8List.fromList(snapshot.data!),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(_selectedImage!.path),
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_existingImage.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _MealImage(
          imagePath: _existingImage,
          height: 150,
          width: double.infinity,
        ),
      );
    }

    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: mintBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.15)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 40, color: primary),
          SizedBox(height: 8),
          Text("No image selected"),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final meal = Meal(
      mealID: widget.initial?.mealID ?? 0,
      mealName: _name.text.trim(),
      mealType: _type.text.trim().isEmpty ? "Healthy" : _type.text.trim(),
      description: _desc.text.trim(),
      protein: num.parse(_pro.text.trim()),
      carbohydrates: num.parse(_carb.text.trim()),
      fat: num.parse(_fat.text.trim()),
      calories: int.parse(_cal.text.trim()),
      image: _existingImage,
      providerID: widget.initial?.providerID ?? "PROV001",
      providerName: widget.initial?.providerName ?? "Main Provider",
    );

    try {
      if (widget.mode == _FormMode.add) {
        await _service.addMeal(meal, imageFile: _selectedImage);
        _showSnack("Meal added successfully!", Colors.green);
      } else {
        await _service.updateMeal(
          meal.mealID,
          meal,
          imageFile: _selectedImage,
        );
        _showSnack("Meal updated successfully!", Colors.blue);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showSnack("Operation failed: $e", Colors.red);
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
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.mode == _FormMode.add ? "Add Meal" : "Edit Meal",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 20),
              _imagePreview(),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_file),
                label: const Text("Choose Image From Device"),
              ),
              const SizedBox(height: 16),
              _input(
                _name,
                "Meal Name",
                validator: (v) => _requiredText(v, "Meal Name"),
              ),
              _input(
                _type,
                "Meal Type",
                validator: (v) => _requiredText(v, "Meal Type"),
              ),
              _input(
                _desc,
                "Description",
                maxLines: 3,
                validator: (v) => _requiredText(v, "Description"),
              ),
              Row(
                children: [
                  Expanded(
                    child: _input(
                      _cal,
                      "Calories",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (v) => _requiredNumber(v, "Calories"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _input(
                      _pro,
                      "Protein",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      validator: (v) => _requiredNumber(v, "Protein"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _input(
                      _carb,
                      "Carbohydrates",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      validator: (v) => _requiredNumber(v, "Carbohydrates"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _input(
                      _fat,
                      "Fat",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      validator: (v) => _requiredNumber(v, "Fat"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                    : const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}