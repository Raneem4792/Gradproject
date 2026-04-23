import 'package:flutter/material.dart';

class AppNotification {
  final int id;
  final String type; 
  final String message;
  final String title;
  final DateTime timestamp;
  bool isUnread;

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.title,
    required this.timestamp,
    this.isUnread = true,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['notificationID'],
      type: json['notificationType'] ?? 'info',
      message: json['messageContent'] ?? '',
      title: _generateTitle(json['notificationType'] ?? 'info'),
      // الحقل في الـ SQL اسمه timestamp
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isUnread: json['isRead'] == 0,
    );
  }

  static String _generateTitle(String type) {
    switch (type.toLowerCase()) {
      case 'success': return "تم قبول الطلب";
      case 'gold': return "تقييم جديد";
      case 'highlight': return "تحديث الحملة";
      default: return "إشعار من النظام";
    }
  }

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'success': return Icons.check_circle_rounded;
      case 'gold': return Icons.star_rounded;
      case 'highlight': return Icons.campaign_rounded;
      default: return Icons.notifications_active_rounded;
    }
  }
}