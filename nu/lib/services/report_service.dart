import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/provider_dashboard_report.dart';

class ReportService {
  final String baseUrl;

  ReportService({required this.baseUrl});

  Future<ProviderDashboardReport> getProviderDashboard(
    String providerId,
    String language,
  ) async {
    final response = await http
        .get(
          Uri.parse(
            '$baseUrl/api/reports/provider-dashboard/$providerId?lang=$language',
          ),
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception('Dashboard request timed out');
          },
        );

    if (response.statusCode == 200) {
      return ProviderDashboardReport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load provider dashboard: ${response.statusCode} ${response.body}',
      );
    }
  }

  String getProviderDashboardPdfUrl(String providerId, String language) {
    return '$baseUrl/api/reports/provider-dashboard/$providerId/pdf?lang=$language';
  }
}