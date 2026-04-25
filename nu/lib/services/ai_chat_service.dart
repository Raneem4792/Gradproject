import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiChatService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  Future<String> sendMessage({
    required String message,
    required String pilgrimID,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai-chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': message,
        'pilgrimID': pilgrimID,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['reply'] ?? 'No reply received.';
    } else {
      throw Exception('Failed to get AI response');
    }
  }
}