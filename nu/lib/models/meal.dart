class Meal {
  final int mealID;

  // Old fields - نخليها عشان ما ينكسر الكود القديم
  final String mealName;
  final String mealType;
  final String description;

  // New bilingual fields
  final String mealNameEn;
  final String mealNameAr;
  final String mealTypeEn;
  final String mealTypeAr;
  final String descriptionEn;
  final String descriptionAr;

  final num protein;
  final num carbohydrates;
  final num fat;
  final int calories;
  final String image;
  final String providerID;
  final String providerName;
  final String? aiReason;

  Meal({
    required this.mealID,
    required this.mealName,
    required this.mealType,
    required this.description,
    this.mealNameEn = '',
    this.mealNameAr = '',
    this.mealTypeEn = '',
    this.mealTypeAr = '',
    this.descriptionEn = '',
    this.descriptionAr = '',
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.calories,
    required this.image,
    required this.providerID,
    required this.providerName,
    this.aiReason,
  });

  static num _toNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    return num.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value.toString()) ??
        num.tryParse(value.toString())?.toInt() ??
        0;
  }

  static String _toStringValue(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    final oldMealName = _toStringValue(json['mealName']);
    final oldMealType = _toStringValue(json['mealType']);
    final oldDescription = _toStringValue(json['description']);

    final mealNameEn = _toStringValue(json['mealName_en']);
    final mealNameAr = _toStringValue(json['mealName_ar']);

    final mealTypeEn = _toStringValue(json['mealType_en']);
    final mealTypeAr = _toStringValue(json['mealType_ar']);

    final descriptionEn = _toStringValue(json['description_en']);
    final descriptionAr = _toStringValue(json['description_ar']);

    return Meal(
      mealID: _toInt(json['mealID']),

      mealName: oldMealName.isNotEmpty
          ? oldMealName
          : mealNameEn.isNotEmpty
          ? mealNameEn
          : mealNameAr.isNotEmpty
          ? mealNameAr
          : 'Unnamed Meal',

      mealType: oldMealType.isNotEmpty
          ? oldMealType
          : mealTypeEn.isNotEmpty
          ? mealTypeEn
          : mealTypeAr.isNotEmpty
          ? mealTypeAr
          : 'Meal',

      description: oldDescription.isNotEmpty
          ? oldDescription
          : descriptionEn.isNotEmpty
          ? descriptionEn
          : descriptionAr,

      mealNameEn: mealNameEn.isNotEmpty ? mealNameEn : oldMealName,
      mealNameAr: mealNameAr.isNotEmpty ? mealNameAr : oldMealName,

      mealTypeEn: mealTypeEn.isNotEmpty ? mealTypeEn : oldMealType,
      mealTypeAr: mealTypeAr.isNotEmpty ? mealTypeAr : oldMealType,

      descriptionEn: descriptionEn.isNotEmpty ? descriptionEn : oldDescription,
      descriptionAr: descriptionAr.isNotEmpty ? descriptionAr : oldDescription,

      protein: _toNum(json['protein']),
      carbohydrates: _toNum(json['carbohydrates']),
      fat: _toNum(json['fat']),
      calories: _toInt(json['calories']),
      image: _toStringValue(json['image']),
      providerID: _toStringValue(json['providerID']),
      providerName: _toStringValue(json['providerName']).isNotEmpty
          ? _toStringValue(json['providerName'])
          : 'Unknown Provider',
      aiReason: json['aiReason']?.toString(),
    );
  }

  String localizedMealName(String languageCode) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    if (isArabic && mealNameAr.trim().isNotEmpty) {
      return mealNameAr;
    }

    if (!isArabic && mealNameEn.trim().isNotEmpty) {
      return mealNameEn;
    }

    return mealName.trim().isNotEmpty ? mealName : 'Unnamed Meal';
  }

  String localizedMealType(String languageCode) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    if (isArabic && mealTypeAr.trim().isNotEmpty) {
      return mealTypeAr;
    }

    if (!isArabic && mealTypeEn.trim().isNotEmpty) {
      return mealTypeEn;
    }

    return mealType.trim().isNotEmpty ? mealType : 'Meal';
  }

  String localizedDescription(String languageCode) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    if (isArabic && descriptionAr.trim().isNotEmpty) {
      return descriptionAr;
    }

    if (!isArabic && descriptionEn.trim().isNotEmpty) {
      return descriptionEn;
    }

    return description;
  }

  String get nutritionLine {
    return '$calories kcal • ${protein}g protein • ${carbohydrates}g carbs • ${fat}g fat';
  }

  bool get isHealthMatched {
    return mealType.toLowerCase() == 'healthy' ||
        mealTypeEn.toLowerCase() == 'healthy';
  }
}
