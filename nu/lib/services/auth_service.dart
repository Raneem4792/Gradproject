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

  Future<User> login({
    required String id,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return User.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Login failed');
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data['message'] ?? 'Signup successful';
    } else {
      throw Exception(data['message'] ?? 'Signup failed');
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data['message'] ?? 'Signup successful';
    } else {
      throw Exception(data['message'] ?? 'Signup failed');
    }
  }
}