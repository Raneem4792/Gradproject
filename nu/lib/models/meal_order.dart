class MealOrder {
  final int orderID;
  final DateTime requestDate;
  final String status;
  final String pilgrimID;
  final int mealID;
  final String mealName;
  final bool isReviewed;
  final int? reviewRating;

  MealOrder({
    required this.orderID,
    required this.requestDate,
    required this.status,
    required this.pilgrimID,
    required this.mealID,
    required this.mealName,
    required this.isReviewed,
    required this.reviewRating,
  });

  factory MealOrder.fromJson(Map<String, dynamic> json) {
    final stars = json['stars'];

    return MealOrder(
      orderID: json['orderID'] ?? 0,
      requestDate:
          DateTime.tryParse(json['requestDate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'pending',
      pilgrimID: json['pilgrimID'] ?? '',
      mealID: json['mealID'] ?? 0,
      mealName: json['mealName'] ?? 'Unknown Meal',

      // ⭐ هنا التعديل المهم
      reviewRating: stars,
      isReviewed: stars != null,
    );
  }

  String get formattedRequestDate {
    return requestDate.toString().split('.').first;
  }
}