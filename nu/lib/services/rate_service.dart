import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/rate.dart';

class RateService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  Future<String> submitRate({
    required int orderID,
    required int stars,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rates'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderID': orderID,
        'stars': stars,
        'comment': comment,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data['message'] ?? 'Review submitted successfully';
    } else {
      throw Exception(data['message'] ?? 'Failed to submit review');
    }
  }

  Future<Rate> getRateByOrder(int orderID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/rates/order/$orderID'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Rate.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Failed to load review');
    }
  }
}