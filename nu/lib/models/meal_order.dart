class MealOrder {
  final int orderID;
  final DateTime requestDate;
  final String status;
  final String pilgrimID;
  final String pilgrimName;
  final int mealID;

  // Old fields
  final String mealName;
  final String mealType;

  // New bilingual fields
  final String mealNameEn;
  final String mealNameAr;
  final String mealTypeEn;
  final String mealTypeAr;

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
    this.mealNameEn = '',
    this.mealNameAr = '',
    this.mealTypeEn = '',
    this.mealTypeAr = '',
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

  static String _toStringValue(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  factory MealOrder.fromJson(Map<String, dynamic> json) {
    final stars = json['stars'];

    final oldMealName = _toStringValue(json['mealName']);
    final oldMealType = _toStringValue(json['mealType']);

    final mealNameEn = _toStringValue(json['mealName_en']);
    final mealNameAr = _toStringValue(json['mealName_ar']);

    final mealTypeEn = _toStringValue(json['mealType_en']);
    final mealTypeAr = _toStringValue(json['mealType_ar']);

    return MealOrder(
      orderID: _toInt(json['orderID']),
      requestDate:
          DateTime.tryParse(json['requestDate']?.toString() ?? '') ??
          DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
      pilgrimID: json['pilgrimID']?.toString() ?? '',
      pilgrimName: json['pilgrimName']?.toString() ?? 'Unknown Pilgrim',
      mealID: _toInt(json['mealID']),

      mealName: oldMealName.isNotEmpty
          ? oldMealName
          : mealNameEn.isNotEmpty
          ? mealNameEn
          : mealNameAr.isNotEmpty
          ? mealNameAr
          : 'Unknown Meal',

      mealType: oldMealType.isNotEmpty
          ? oldMealType
          : mealTypeEn.isNotEmpty
          ? mealTypeEn
          : mealTypeAr.isNotEmpty
          ? mealTypeAr
          : 'Meal',

      mealNameEn: mealNameEn.isNotEmpty ? mealNameEn : oldMealName,
      mealNameAr: mealNameAr.isNotEmpty ? mealNameAr : oldMealName,
      mealTypeEn: mealTypeEn.isNotEmpty ? mealTypeEn : oldMealType,
      mealTypeAr: mealTypeAr.isNotEmpty ? mealTypeAr : oldMealType,

      campaignID: json['campaignID']?.toString(),
      campaignName: json['campaignName']?.toString() ?? 'Unknown Campaign',
      campaignNumber: json['campaignNumber']?.toString() ?? '',
      reviewRating: stars == null ? null : _toInt(stars),
      isReviewed: stars != null,
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

    return mealName;
  }

  String localizedMealType(String languageCode) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    if (isArabic && mealTypeAr.trim().isNotEmpty) {
      return mealTypeAr;
    }

    if (!isArabic && mealTypeEn.trim().isNotEmpty) {
      return mealTypeEn;
    }

    return mealType;
  }

  String get formattedRequestDate {
    final d = requestDate.day.toString().padLeft(2, '0');
    final m = requestDate.month.toString().padLeft(2, '0');
    final y = requestDate.year.toString();

    return '$d/$m/$y';
  }
}
