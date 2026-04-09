import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/campaign.dart';

class CampaignService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

Future<List<Campaign>> getCampaignsByProvider(String providerID) async {
  final url = Uri.parse('$baseUrl/campaigns/provider/$providerID');
  print('REQUEST URL = $url');

  final response = await http
      .get(url)
      .timeout(const Duration(seconds: 10));

  print('STATUS CODE = ${response.statusCode}');
  print('BODY = ${response.body}');

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Campaign.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load campaigns: ${response.body}');
  }
}

  Future<void> createCampaign({
    required String campaignName,
    required String campaignNumber,
    required int numberOfPilgrims,
    required String arrivalDetails,
    required String providerID,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/campaigns'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'campaignName': campaignName,
        'campaignNumber': campaignNumber,
        'numberOfPilgrims': numberOfPilgrims,
        'arrivalDetails': arrivalDetails,
        'providerID': providerID,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create campaign: ${response.body}');
    }
  }

  Future<void> updateCampaign({
    required int campaignID,
    required String campaignName,
    required String campaignNumber,
    required int numberOfPilgrims,
    required String arrivalDetails,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/campaigns/$campaignID'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'campaignName': campaignName,
        'campaignNumber': campaignNumber,
        'numberOfPilgrims': numberOfPilgrims,
        'arrivalDetails': arrivalDetails,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update campaign: ${response.body}');
    }
  }

  Future<void> deleteCampaign(int campaignID) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/campaigns/$campaignID'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete campaign: ${response.body}');
    }
  }
}