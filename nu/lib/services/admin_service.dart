import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/admin_account_tree.dart';
import '../models/admin_orders_monitor.dart';

class AdminService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    return 'http://10.0.2.2:3000/api';
  }

  Future<List<AdminProviderAccount>> getAccountsTree() async {
    final url = Uri.parse('$baseUrl/admin/accounts-tree');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => AdminProviderAccount.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load accounts tree');
    }
  }

  Future<List<AdminOrdersCampaign>> getOrdersMonitor() async {
  final url = Uri.parse('$baseUrl/admin/orders-monitor');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((item) => AdminOrdersCampaign.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load orders monitor');
  }
}
}