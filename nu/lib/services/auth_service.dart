import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  String _extractMessage(
    http.Response response, {
    String fallback = 'Request failed',
  }) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['message'] != null) {
        return data['message'].toString();
      }
      return fallback;
    } catch (_) {
      return fallback;
    }
  }

  Future<User> login({required String id, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception(
        _extractMessage(
          response,
          fallback: 'Login failed. Please check your ID and password.',
        ),
      );
    }
  }

  Future<String> signupPilgrim({
    required String pilgrimID,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required int campaignID,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup/pilgrim'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pilgrimID': pilgrimID,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'campaignID': campaignID,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Signup successful';
    } else {
      throw Exception(response.body);
    }
  }

  Future<String> signupProvider({
    required String providerID,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup/provider'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'providerID': providerID,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Signup successful';
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> sendResetCode(String email) async {
  final response = await http.post(
    Uri.parse('$baseUrl/password-reset/send-code'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to send code');
  }
}

Future<void> resetPassword({
  required String email,
  required String code,
  required String newPassword,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/password-reset/reset-password'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'code': code,
      'newPassword': newPassword,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to reset password');
  }
}
}
