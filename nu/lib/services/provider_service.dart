import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/provider_profile.dart';

class ProviderService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  Future<Map<String, dynamic>> getProviderHomeData(String providerID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/providers/home/$providerID'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load provider home data: ${response.body}');
    }
  }

  Future<ProviderProfile> getProfile(String providerID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/providers/$providerID'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProviderProfile.fromJson(data);
    } else {
      throw Exception(
        'Failed to load provider profile: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<String> updateProfile(ProviderProfile profile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/providers/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'providerID': profile.providerID,
        'fullName': profile.fullName,
        'email': profile.email,
        'phoneNumber': profile.phoneNumber,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'] ?? 'Profile updated successfully';
    } else {
      throw Exception(data['message'] ?? 'Failed to update provider profile');
    }
  }

  Future<Map<String, dynamic>> getProfileSummary(String providerID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/providers/profile-summary/$providerID'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load provider profile summary: ${response.body}',
      );
    }
  }
}
