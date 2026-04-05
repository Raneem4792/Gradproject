class HealthProfile {
  final String pilgrimID;
  final String dietaryPreferences;
  final String healthConditions;
  final String allergies;
  final int age;

  HealthProfile({
    required this.pilgrimID,
    required this.dietaryPreferences,
    required this.healthConditions,
    required this.allergies,
    required this.age,
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  factory HealthProfile.fromJson(Map<String, dynamic> json) {
    return HealthProfile(
      pilgrimID: json['pilgrimID'] ?? '',
      dietaryPreferences: json['dietaryPreferences'] ?? '',
      healthConditions: json['healthConditions'] ?? '',
      allergies: json['allergies'] ?? '',
      age: _toInt(json['age']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pilgrimID': pilgrimID,
      'dietaryPreferences': dietaryPreferences,
      'healthConditions': healthConditions,
      'allergies': allergies,
      'age': age,
    };
  }

  List<String> get allergyList {
    if (allergies.trim().isEmpty) return [];
    return allergies
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}