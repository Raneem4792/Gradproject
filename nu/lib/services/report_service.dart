import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/provider_dashboard_report.dart';

class ReportService {
  final String baseUrl;

  ReportService({required this.baseUrl});

  Future<ProviderDashboardReport> getProviderDashboard(
    String providerId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/reports/provider-dashboard/$providerId'),
    );

    if (response.statusCode == 200) {
      return ProviderDashboardReport.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load provider dashboard');
  }
}
