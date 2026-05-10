import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/meal.dart';
import '../models/meal_order.dart';
import '../models/notification_model.dart';

class MealService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  // يحول أي رد من السيرفر إلى List بشكل آمن
  List<dynamic> _extractList(
    dynamic decoded, {
    String? key,
    List<String> possibleKeys = const [],
  }) {
    if (decoded == null) return [];

    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map) {
      final map = Map<String, dynamic>.from(decoded);

      if (key != null && map[key] is List) {
        return map[key] as List;
      }

      for (final possibleKey in possibleKeys) {
        if (map[possibleKey] is List) {
          return map[possibleKey] as List;
        }
      }

      for (final possibleKey in const [
        'data',
        'meals',
        'orders',
        'campaigns',
        'notifications',
        'results',
      ]) {
        if (map[possibleKey] is List) {
          return map[possibleKey] as List;
        }
      }

      // احتياط لو السيرفر رجع Map مثل:
      // { "1": {...}, "2": {...} }
      return map.values.toList();
    }

    return [];
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  String _extractErrorMessage(String responseBody, String fallback) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is Map && decoded['message'] != null) {
        return decoded['message'].toString();
      }

      if (decoded is Map && decoded['error'] != null) {
        return decoded['error'].toString();
      }

      return fallback;
    } catch (_) {
      return fallback;
    }
  }

  // جلب كل الوجبات
  Future<List<Meal>> getMeals() async {
    final response = await http.get(Uri.parse('$baseUrl/meals'));

    print('GET MEALS STATUS CODE: ${response.statusCode}');
    print('GET MEALS RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = _extractList(
        decoded,
        key: 'meals',
        possibleKeys: const ['data', 'meals', 'results'],
      );

      return data.map((item) => Meal.fromJson(_asMap(item))).toList();
    } else {
      throw Exception(
        _extractErrorMessage(response.body, 'Failed to load meals'),
      );
    }
  }

  // تجهيز ملف الصورة بحيث يشتغل على web والموبايل
  Future<http.MultipartFile?> _buildImageFile(XFile? imageFile) async {
    if (imageFile == null) return null;

    if (kIsWeb) {
      Uint8List bytes = await imageFile.readAsBytes();

      return http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: imageFile.name,
      );
    } else {
      return await http.MultipartFile.fromPath('image', imageFile.path);
    }
  }

  // إضافة وجبة جديدة
  Future<void> addMeal(Meal meal, {XFile? imageFile}) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/meals/add'),
    );

    request.fields['mealName'] = meal.mealName;
    request.fields['mealType'] = meal.mealType;
    request.fields['description'] = meal.description;
    request.fields['protein'] = meal.protein.toString();
    request.fields['carbohydrates'] = meal.carbohydrates.toString();
    request.fields['fat'] = meal.fat.toString();
    request.fields['calories'] = meal.calories.toString();
    request.fields['providerID'] = meal.providerID;

    if (meal.image.isNotEmpty) {
      request.fields['existingImage'] = meal.image;
    }

    final imageMultipart = await _buildImageFile(imageFile);

    if (imageMultipart != null) {
      request.files.add(imageMultipart);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('ADD MEAL STATUS CODE: ${response.statusCode}');
    print('ADD MEAL RESPONSE BODY: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          'Failed to add meal. Server response: ${response.body}',
        ),
      );
    }
  }

  // تعديل وجبة
  Future<void> updateMeal(int mealID, Meal meal, {XFile? imageFile}) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/meals/update/$mealID'),
    );

    request.fields['mealName'] = meal.mealName;
    request.fields['mealType'] = meal.mealType;
    request.fields['description'] = meal.description;
    request.fields['protein'] = meal.protein.toString();
    request.fields['carbohydrates'] = meal.carbohydrates.toString();
    request.fields['fat'] = meal.fat.toString();
    request.fields['calories'] = meal.calories.toString();

    if (meal.image.isNotEmpty) {
      request.fields['existingImage'] = meal.image;
    }

    final imageMultipart = await _buildImageFile(imageFile);

    if (imageMultipart != null) {
      request.files.add(imageMultipart);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('UPDATE MEAL STATUS CODE: ${response.statusCode}');
    print('UPDATE MEAL RESPONSE BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          'Failed to update meal. Server response: ${response.body}',
        ),
      );
    }
  }

  // حذف وجبة
  Future<void> deleteMeal(int mealID) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/meals/delete/$mealID'),
    );

    print('DELETE MEAL STATUS CODE: ${response.statusCode}');
    print('DELETE MEAL RESPONSE BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, 'Failed to delete meal'),
      );
    }
  }

  // إنشاء طلب جديد للحاج
  Future<Map<String, dynamic>> createOrder({
    required int mealID,
    required String pilgrimID,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mealID': mealID, 'pilgrimID': pilgrimID}),
    );

    print('CREATE ORDER STATUS CODE: ${response.statusCode}');
    print('CREATE ORDER RESPONSE BODY: ${response.body}');

    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    final data = _asMap(decoded);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message']?.toString() ?? 'Failed to create order');
    }
  }

  // جلب طلبات الحاج
  Future<List<MealOrder>> getOrdersByPilgrim(String pilgrimID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/pilgrim/$pilgrimID'),
    );

    print('GET PILGRIM ORDERS STATUS CODE: ${response.statusCode}');
    print('GET PILGRIM ORDERS RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = _extractList(
        decoded,
        key: 'orders',
        possibleKeys: const ['data', 'orders', 'results'],
      );

      return data.map((item) => MealOrder.fromJson(_asMap(item))).toList();
    } else {
      throw Exception(
        _extractErrorMessage(
          response.body,
          'Failed to load orders: ${response.statusCode}',
        ),
      );
    }
  }

  // جلب حملات المزود
  Future<List<Map<String, dynamic>>> getProviderCampaigns(
    String providerID,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/provider/$providerID/campaigns'),
    );

    print('GET PROVIDER CAMPAIGNS STATUS CODE: ${response.statusCode}');
    print('GET PROVIDER CAMPAIGNS RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = _extractList(
        decoded,
        key: 'campaigns',
        possibleKeys: const ['data', 'campaigns', 'results'],
      );

      return data.map((item) => _asMap(item)).toList();
    } else {
      throw Exception(
        _extractErrorMessage(response.body, 'Failed to load campaigns'),
      );
    }
  }

  // جلب طلبات المزود مع فلتر الحملة
  Future<List<MealOrder>> getOrdersByProvider(
    String providerID, {
    String? campaignID,
  }) async {
    final uri = Uri.parse('$baseUrl/orders/provider/$providerID').replace(
      queryParameters: campaignID == null || campaignID.isEmpty
          ? null
          : {'campaignID': campaignID},
    );

    final response = await http.get(uri);

    print('GET PROVIDER ORDERS STATUS CODE: ${response.statusCode}');
    print('GET PROVIDER ORDERS RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = _extractList(
        decoded,
        key: 'orders',
        possibleKeys: const ['data', 'orders', 'results'],
      );

      return data.map((item) => MealOrder.fromJson(_asMap(item))).toList();
    } else {
      throw Exception(
        _extractErrorMessage(response.body, 'Failed to load provider orders'),
      );
    }
  }

  // تقييم الطلب
  Future<void> createRate({
    required int orderID,
    required int stars,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderID': orderID,
        'stars': stars,
        'comment': comment,
      }),
    );

    print('CREATE RATE STATUS CODE: ${response.statusCode}');
    print('CREATE RATE RESPONSE BODY: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(response.body, 'Failed to submit rating'),
      );
    }
  }

  // تحديث حالة الطلب
  Future<String> updateOrderStatus({
    required int orderID,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/$orderID/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    print('UPDATE ORDER STATUS CODE: ${response.statusCode}');
    print('UPDATE ORDER RESPONSE BODY: ${response.body}');

    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    final data = _asMap(decoded);

    if (response.statusCode == 200) {
      return data['message']?.toString() ?? 'Order status updated successfully';
    } else {
      throw Exception(
        data['message']?.toString() ?? 'Failed to update order status',
      );
    }
  }

  // جلب الإشعارات
  Future<List<AppNotification>> getNotifications(
    String userId,
    String userType,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/$userId/$userType'),
      );

      print('GET NOTIFICATIONS STATUS CODE: ${response.statusCode}');
      print('GET NOTIFICATIONS RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = _extractList(
          decoded,
          key: 'notifications',
          possibleKeys: const ['data', 'notifications', 'results'],
        );

        return data
            .map((item) => AppNotification.fromJson(_asMap(item)))
            .toList();
      } else {
        print('Server Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  // جلب الوجبات المقترحة بالذكاء الاصطناعي
  Future<List<Meal>> getAiRecommendedMeals(String pilgrimID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/meals/ai-recommended/$pilgrimID'),
    );

    print('GET AI MEALS STATUS CODE: ${response.statusCode}');
    print('GET AI MEALS RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = _extractList(
        decoded,
        key: 'meals',
        possibleKeys: const ['data', 'meals', 'recommendedMeals', 'results'],
      );

      return data.map((item) => Meal.fromJson(_asMap(item))).toList();
    } else {
      throw Exception(
        _extractErrorMessage(
          response.body,
          'Failed to load AI recommended meals',
        ),
      );
    }
  }

  // جلب وجبات المزود
  Future<List<Meal>> getMealsByProvider(String providerID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/meals/provider/$providerID'),
    );

    print('GET PROVIDER MEALS STATUS CODE: ${response.statusCode}');
    print('GET PROVIDER MEALS RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = _extractList(
        decoded,
        key: 'meals',
        possibleKeys: const ['data', 'meals', 'results'],
      );

      return data.map((item) => Meal.fromJson(_asMap(item))).toList();
    } else {
      throw Exception(
        _extractErrorMessage(response.body, 'Failed to load provider meals'),
      );
    }
  }

  // جلب وجبات حملة الحاج
  Future<List<Meal>> getMealsByPilgrimCampaign(String pilgrimID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/meals/pilgrim/$pilgrimID/campaign'),
    );

    print('GET CAMPAIGN MEALS STATUS CODE: ${response.statusCode}');
    print('GET CAMPAIGN MEALS RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = _extractList(
        decoded,
        key: 'meals',
        possibleKeys: const ['data', 'meals', 'campaignMeals', 'results'],
      );

      return data.map((item) => Meal.fromJson(_asMap(item))).toList();
    } else {
      throw Exception(
        _extractErrorMessage(response.body, 'Failed to load campaign meals'),
      );
    }
  }
}
