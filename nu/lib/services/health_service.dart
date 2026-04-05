import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/health_profile.dart';

class HealthService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  // ✅ GET PROFILE
  Future<HealthProfile> getProfile(String pilgrimID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/health/$pilgrimID'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HealthProfile.fromJson(data); // 🔥 أهم تعديل
    } else {
      throw Exception(
        'Failed to load profile: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // ✅ SAVE PROFILE
  Future<String> saveProfile(HealthProfile profile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/health'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()), // 🔥 أهم تعديل
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseData['message'] ?? 'Profile saved successfully';
    } else {
      throw Exception(
        responseData['message'] ?? 'Failed to save profile',
      );
    }
  }
}