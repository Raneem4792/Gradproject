import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiDashboardService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  Future<String> getProviderAnalysis(String providerID) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai-dashboard-analysis'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'providerID': providerID,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['analysis'] ?? 'No AI analysis available.';
    } else {
      throw Exception('Failed to load AI analysis');
    }
  }
}