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
      provider: AdminOrdersProvider.fromJson(json['provider'] ?? {}),
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map((item) => AdminOrderItem.fromJson(item))
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
  final String mealName;
  final String mealType;
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
    required this.calories,
  });

  factory AdminOrderItem.fromJson(Map<String, dynamic> json) {
    return AdminOrderItem(
      orderID: int.tryParse(json['orderID']?.toString() ?? '') ?? 0,
      requestDate: json['requestDate']?.toString(),
      status: json['status']?.toString() ?? '',
      pilgrimID: json['pilgrimID']?.toString() ?? '',
      pilgrimName: json['pilgrimName']?.toString() ?? '',
      pilgrimEmail: json['pilgrimEmail']?.toString() ?? '',
      mealID: int.tryParse(json['mealID']?.toString() ?? '') ?? 0,
      mealName: json['mealName']?.toString() ?? '',
      mealType: json['mealType']?.toString() ?? '',
      calories: int.tryParse(json['calories']?.toString() ?? '') ?? 0,
    );
  }
}