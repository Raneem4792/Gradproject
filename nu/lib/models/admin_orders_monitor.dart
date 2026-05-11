class AdminOrdersCampaign {
  final int campaignID;
  final String campaignName;
  final String? campaignNumber;
  final AdminOrdersProvider provider;
  final List<AdminOrderItem> orders;

  AdminOrdersCampaign({
    required this.campaignID,
    required this.campaignName,
    this.campaignNumber,
    required this.provider,
    required this.orders,
  });

  factory AdminOrdersCampaign.fromJson(Map<String, dynamic> json) {
    return AdminOrdersCampaign(
      campaignID: int.tryParse(json['campaignID']?.toString() ?? '') ?? 0,
      campaignName: json['campaignName']?.toString() ?? '',
      campaignNumber: json['campaignNumber']?.toString(),
      provider: AdminOrdersProvider.fromJson(
        Map<String, dynamic>.from(json['provider'] ?? {}),
      ),
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map(
            (item) => AdminOrderItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }
}

class AdminOrdersProvider {
  final String providerID;
  final String providerName;
  final String providerEmail;

  AdminOrdersProvider({
    required this.providerID,
    required this.providerName,
    required this.providerEmail,
  });

  factory AdminOrdersProvider.fromJson(Map<String, dynamic> json) {
    return AdminOrdersProvider(
      providerID: json['providerID']?.toString() ?? '',
      providerName: json['providerName']?.toString() ?? '',
      providerEmail: json['providerEmail']?.toString() ?? '',
    );
  }
}

class AdminOrderItem {
  final int orderID;
  final String? requestDate;
  final String status;

  final String pilgrimID;
  final String pilgrimName;
  final String pilgrimEmail;

  final int mealID;

  // Old fields
  final String mealName;
  final String mealType;

  // New bilingual fields
  final String mealNameAr;
  final String mealNameEn;
  final String mealTypeAr;
  final String mealTypeEn;

  final int calories;

  AdminOrderItem({
    required this.orderID,
    this.requestDate,
    required this.status,
    required this.pilgrimID,
    required this.pilgrimName,
    required this.pilgrimEmail,
    required this.mealID,
    required this.mealName,
    required this.mealType,
    this.mealNameAr = '',
    this.mealNameEn = '',
    this.mealTypeAr = '',
    this.mealTypeEn = '',
    required this.calories,
  });

  factory AdminOrderItem.fromJson(Map<String, dynamic> json) {
    final oldMealName = json['mealName']?.toString() ?? '';
    final oldMealType = json['mealType']?.toString() ?? '';

    final mealNameAr = json['mealName_ar']?.toString() ?? '';
    final mealNameEn = json['mealName_en']?.toString() ?? '';

    final mealTypeAr = json['mealType_ar']?.toString() ?? '';
    final mealTypeEn = json['mealType_en']?.toString() ?? '';

    return AdminOrderItem(
      orderID: int.tryParse(json['orderID']?.toString() ?? '') ?? 0,
      requestDate: json['requestDate']?.toString(),
      status: json['status']?.toString() ?? '',
      pilgrimID: json['pilgrimID']?.toString() ?? '',
      pilgrimName: json['pilgrimName']?.toString() ?? '',
      pilgrimEmail: json['pilgrimEmail']?.toString() ?? '',
      mealID: int.tryParse(json['mealID']?.toString() ?? '') ?? 0,

      mealName: oldMealName.isNotEmpty
          ? oldMealName
          : mealNameEn.isNotEmpty
          ? mealNameEn
          : mealNameAr,

      mealType: oldMealType.isNotEmpty
          ? oldMealType
          : mealTypeEn.isNotEmpty
          ? mealTypeEn
          : mealTypeAr,

      mealNameAr: mealNameAr.isNotEmpty ? mealNameAr : oldMealName,
      mealNameEn: mealNameEn.isNotEmpty ? mealNameEn : oldMealName,
      mealTypeAr: mealTypeAr.isNotEmpty ? mealTypeAr : oldMealType,
      mealTypeEn: mealTypeEn.isNotEmpty ? mealTypeEn : oldMealType,

      calories: int.tryParse(json['calories']?.toString() ?? '') ?? 0,
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
}
