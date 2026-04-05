class Meal {
  final int mealID;
  final String mealName;
  final String mealType;
  final String description;
  final num protein;
  final num carbohydrates;
  final num fat;
  final int calories;
  final String image;
  final String providerID;
  final String providerName;

  Meal({
    required this.mealID,
    required this.mealName,
    required this.mealType,
    required this.description,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.calories,
    required this.image,
    required this.providerID,
    required this.providerName,
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

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealID: _toInt(json['mealID']),
      mealName: json['mealName'] ?? 'Unnamed Meal',
      mealType: json['mealType'] ?? 'Meal',
      description: json['description'] ?? '',
      protein: _toNum(json['protein']),
      carbohydrates: _toNum(json['carbohydrates']),
      fat: _toNum(json['fat']),
      calories: _toInt(json['calories']),
      image: json['image'] ?? '',
      providerID: json['providerID'] ?? '',
      providerName: json['providerName'] ?? 'Unknown Provider',
    );
  }

  String get nutritionLine {
    return '$calories kcal • ${protein}g protein • ${carbohydrates}g carbs • ${fat}g fat';
  }

  bool get isHealthMatched {
    return mealType.toLowerCase() == 'healthy';
  }
}