import 'package:flutter/material.dart';

class AppNotification {
  final int id;
  final String type;

  // Old fields
  final String message;
  final String title;

  // New bilingual fields
  final String titleAr;
  final String titleEn;
  final String messageAr;
  final String messageEn;

  final DateTime timestamp;
  bool isUnread;

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.title,
    this.titleAr = '',
    this.titleEn = '',
    this.messageAr = '',
    this.messageEn = '',
    required this.timestamp,
    this.isUnread = true,
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value.toString()) ?? 0;
  }

  static String _toStringValue(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static bool _toUnread(dynamic value) {
    if (value == null) return true;

    if (value is bool) {
      return !value;
    }

    if (value is int) {
      return value == 0;
    }

    final text = value.toString().toLowerCase().trim();

    if (text == '0' || text == 'false') return true;
    if (text == '1' || text == 'true') return false;

    return true;
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final type = _toStringValue(json['notificationType']).isNotEmpty
        ? _toStringValue(json['notificationType'])
        : 'info';

    final oldTitle = _toStringValue(json['title']);
    final oldMessage = _toStringValue(json['messageContent']);

    final titleAr = _toStringValue(json['title_ar']);
    final titleEn = _toStringValue(json['title_en']);

    final messageAr = _toStringValue(json['messageContent_ar']);
    final messageEn = _toStringValue(json['messageContent_en']);

    final fallbackTitleAr = _generateTitle(type, 'ar');
    final fallbackTitleEn = _generateTitle(type, 'en');

    return AppNotification(
      id: _toInt(json['notificationID']),
      type: type,

      title: oldTitle.isNotEmpty
          ? oldTitle
          : titleAr.isNotEmpty
          ? titleAr
          : titleEn.isNotEmpty
          ? titleEn
          : fallbackTitleAr,

      message: oldMessage.isNotEmpty
          ? oldMessage
          : messageAr.isNotEmpty
          ? messageAr
          : messageEn,

      titleAr: titleAr.isNotEmpty
          ? titleAr
          : oldTitle.isNotEmpty
          ? oldTitle
          : fallbackTitleAr,

      titleEn: titleEn.isNotEmpty
          ? titleEn
          : oldTitle.isNotEmpty
          ? oldTitle
          : fallbackTitleEn,

      messageAr: messageAr.isNotEmpty ? messageAr : oldMessage,
      messageEn: messageEn.isNotEmpty ? messageEn : oldMessage,

      timestamp:
          DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),

      isUnread: _toUnread(json['isRead']),
    );
  }

  String localizedTitle(String languageCode) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    if (isArabic && titleAr.trim().isNotEmpty) {
      return titleAr;
    }

    if (!isArabic && titleEn.trim().isNotEmpty) {
      return titleEn;
    }

    return title.trim().isNotEmpty
        ? title
        : _generateTitle(type, isArabic ? 'ar' : 'en');
  }

  String localizedMessage(String languageCode) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    if (isArabic && messageAr.trim().isNotEmpty) {
      return messageAr;
    }

    if (!isArabic && messageEn.trim().isNotEmpty) {
      return messageEn;
    }

    return message;
  }

  static String _generateTitle(String type, String languageCode) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    switch (type.toLowerCase()) {
      case 'success':
        return isArabic ? 'تم قبول الطلب' : 'Order Accepted';
      case 'gold':
        return isArabic ? 'تقييم جديد' : 'New Rating';
      case 'highlight':
        return isArabic ? 'تحديث جديد' : 'New Update';
      case 'alert':
        return isArabic ? 'تنبيه' : 'Alert';
      case 'info':
        return isArabic ? 'إشعار من النظام' : 'System Notification';
      default:
        return isArabic ? 'إشعار من النظام' : 'System Notification';
    }
  }

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'success':
        return Icons.check_circle_rounded;
      case 'gold':
        return Icons.star_rounded;
      case 'highlight':
        return Icons.campaign_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }
}
