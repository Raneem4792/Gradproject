class MealOrder {
  final int orderID;
  final DateTime requestDate;
  final String status;
  final String pilgrimID;
  final String pilgrimName;
  final int mealID;
  final String mealName;
  final String mealType;
  final String? campaignID;
  final String campaignName;
  final String campaignNumber;
  final bool isReviewed;
  final int? reviewRating;

  MealOrder({
    required this.orderID,
    required this.requestDate,
    required this.status,
    required this.pilgrimID,
    required this.pilgrimName,
    required this.mealID,
    required this.mealName,
    required this.mealType,
    required this.campaignID,
    required this.campaignName,
    required this.campaignNumber,
    required this.isReviewed,
    required this.reviewRating,
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  factory MealOrder.fromJson(Map<String, dynamic> json) {
    final stars = json['stars'];

    return MealOrder(
      orderID: _toInt(json['orderID']),
      requestDate:
          DateTime.tryParse(json['requestDate']?.toString() ?? '') ??
          DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
      pilgrimID: json['pilgrimID']?.toString() ?? '',
      pilgrimName: json['pilgrimName']?.toString() ?? 'Unknown Pilgrim',
      mealID: _toInt(json['mealID']),
      mealName: json['mealName']?.toString() ?? 'Unknown Meal',
      mealType: json['mealType']?.toString() ?? 'Meal',
      campaignID: json['campaignID']?.toString(),
      campaignName: json['campaignName']?.toString() ?? 'Unknown Campaign',
      campaignNumber: json['campaignNumber']?.toString() ?? '',
      reviewRating: stars == null ? null : _toInt(stars),
      isReviewed: stars != null,
    );
  }

  String get formattedRequestDate {
    final d = requestDate.day.toString().padLeft(2, '0');
    final m = requestDate.month.toString().padLeft(2, '0');
    final y = requestDate.year.toString();
    return '$d/$m/$y';
  }
}