import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pilgrim_profile.dart';

class PilgrimService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  // ✅ Home data
  Future<Map<String, dynamic>> getPilgrimHomeData(String pilgrimID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pilgrims/home/$pilgrimID'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load pilgrim home data: ${response.body}');
    }
  }

  // ✅ Profile data
  Future<PilgrimProfile> getProfile(String pilgrimID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pilgrims/$pilgrimID'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PilgrimProfile.fromJson(data);
    } else {
      throw Exception(
        'Failed to load pilgrim profile: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // ✅ Update profile
  Future<String> updateProfile(PilgrimProfile profile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pilgrims/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pilgrimID': profile.pilgrimID,
        'fullName': profile.fullName,
        'email': profile.email,
        'phoneNumber': profile.phoneNumber,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'] ?? 'Profile updated successfully';
    } else {
      throw Exception(
        data['message'] ?? 'Failed to update profile',
      );
    }
  }
}