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

      return data.map((item) => AdminProviderAccount.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load accounts tree');
    }
  }

  Future<List<AdminOrdersCampaign>> getOrdersMonitor() async {
    final url = Uri.parse('$baseUrl/admin/orders-monitor');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((item) => AdminOrdersCampaign.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load orders monitor');
    }
  }

  Future<List<dynamic>> getSentNotifications() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/notifications'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> createNotification({
    required String titleAr,
    required String titleEn,
    required String messageAr,
    required String messageEn,
    required String notificationType,
    required String recipientType,
    String? recipientUserID,
    String? createdByAdminID,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/notifications'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleEn.trim().isNotEmpty ? titleEn.trim() : titleAr.trim(),
        'title_ar': titleAr.trim(),
        'title_en': titleEn.trim(),
        'notificationType': notificationType.trim(),
        'messageContent': messageEn.trim().isNotEmpty
            ? messageEn.trim()
            : messageAr.trim(),
        'messageContent_ar': messageAr.trim(),
        'messageContent_en': messageEn.trim(),
        'recipientType': recipientType.trim(),
        'recipientUserID': recipientUserID?.trim() ?? '',
        'createdByAdminID': createdByAdminID?.trim() ?? '',
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send notification');
    }
  }

  Future<void> updateAccountStatus({
  required String accountType,
  required String accountID,
  required String status,
}) async {
  final response = await http.patch(
    Uri.parse(
      '$baseUrl/admin/accounts/$accountType/$accountID/status',
    ),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'status': status,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update account status');
  }
}

Future<void> updateAccountInfo({
  required String accountType,
  required String accountID,
  required String fullName,
  required String email,
  required String phoneNumber,
}) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/admin/accounts/$accountType/$accountID'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update account information');
  }
}

Future<List<dynamic>> getAdminReceivedNotifications(
  String adminID,
) async {
  final response = await http.get(
    Uri.parse(
      '$baseUrl/admin/notifications/received/$adminID',
    ),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load admin notifications');
  }
}

Future<int> getAdminUnreadCount(String adminID) async {
  final response = await http.get(
    Uri.parse('$baseUrl/admin/notifications/unread-count/$adminID'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['count'] ?? 0;
  } else {
    throw Exception('Failed to load unread count');
  }
}

Future<void> markAdminNotificationAsRead(int notificationID) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/notifications/$notificationID/read'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to mark notification as read');
  }
}

Future<void> markAllAdminNotificationsAsRead(String adminID) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/notifications/mark-all-read/$adminID'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to mark all notifications as read');
  }
}

}
