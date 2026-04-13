class ProviderDashboardReport {
  final String updatedAt;
  final int todayOrders;
  final int campaigns;
  final int mealAcceptance;
  final double averageScore;
  final int starsFilled;
  final List<String> aiSuggestions;
  final Map<String, int> healthSnapshot;
  final List<Map<String, dynamic>> orderTrend;
  final List<Map<String, dynamic>> topMeals;
  final int totalReviews;
  final int highestScore;
  final String latestReview;

  ProviderDashboardReport({
    required this.updatedAt,
    required this.todayOrders,
    required this.campaigns,
    required this.mealAcceptance,
    required this.averageScore,
    required this.starsFilled,
    required this.totalReviews,
    required this.highestScore,
    required this.latestReview,
    required this.aiSuggestions,
    required this.healthSnapshot,
    required this.orderTrend,
    required this.topMeals,
  });

  factory ProviderDashboardReport.fromJson(Map<String, dynamic> json) {
    return ProviderDashboardReport(
      updatedAt: json['updatedAt'] ?? '',
      todayOrders: json['overview']?['todayOrders'] ?? 0,
      campaigns: json['kpis']?['campaigns']?['value'] ?? 0,
      mealAcceptance: json['kpis']?['mealAcceptance']?['value'] ?? 0,
      averageScore:
          (json['feedback']?['averageScore'] as num?)?.toDouble() ?? 0.0,
      starsFilled: json['feedback']?['starsFilled'] ?? 0,
      totalReviews: json['feedback']?['totalReviews'] ?? 0,
      highestScore: json['feedback']?['highestScore'] ?? 0,
      latestReview: json['feedback']?['latestReview'] ?? 'No reviews yet',
      aiSuggestions: List<String>.from(json['aiSuggestions'] ?? const []),
      healthSnapshot: {
        'diabetes': json['healthSnapshot']?['diabetes'] ?? 0,
        'allergies': json['healthSnapshot']?['allergies'] ?? 0,
        'lowSodium': json['healthSnapshot']?['lowSodium'] ?? 0,
        'highProtein': json['healthSnapshot']?['highProtein'] ?? 0,
      },
      orderTrend: List<Map<String, dynamic>>.from(
        json['demandTrend'] ?? const [],
      ),
      topMeals: List<Map<String, dynamic>>.from(json['topMeals'] ?? const []),
    );
  }
}
