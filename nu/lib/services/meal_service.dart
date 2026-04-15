import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/meal.dart';
import '../models/meal_order.dart';

class MealService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  // ✅ جلب كل الوجبات
  Future<List<Meal>> getMeals() async {
    final response = await http.get(Uri.parse('$baseUrl/meals'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // ✅ تجهيز ملف الصورة بحيث يشتغل على web والموبايل
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
      return await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      );
    }
  }

  // ✅ إضافة وجبة جديدة
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
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Failed to add meal');
      } catch (_) {
        throw Exception(
          'Failed to add meal. Server response: ${response.body}',
        );
      }
    }
  }

  // ✅ تعديل وجبة
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
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Failed to update meal');
      } catch (_) {
        throw Exception(
          'Failed to update meal. Server response: ${response.body}',
        );
      }
    }
  }

  // ✅ حذف وجبة
  Future<void> deleteMeal(int mealID) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/meals/delete/$mealID'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete meal');
    }
  }

  // ✅ إنشاء طلب جديد (للحاج)
  Future<Map<String, dynamic>> createOrder({
    required int mealID,
    required String pilgrimID,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mealID': mealID,
        'pilgrimID': pilgrimID,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to create order');
    }
  }

  // ✅ جلب طلبات الحاج
  Future<List<MealOrder>> getOrdersByPilgrim(String pilgrimID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/pilgrim/$pilgrimID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MealOrder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }

  // ✅ جلب حملات المزود
  Future<List<Map<String, dynamic>>> getProviderCampaigns(
    String providerID,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/provider/$providerID/campaigns'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to load campaigns');
    }
  }

  // ✅ جلب طلبات المزود مع فلتر الحملة
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

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MealOrder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load provider orders');
    }
  }

  // ✅ تقييم الطلب
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

    if (response.statusCode != 201) {
      throw Exception('Failed to submit rating');
    }
  }

  // ✅ تحديث حالة الطلب
  Future<String> updateOrderStatus({
    required int orderID,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/$orderID/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'] ?? 'Order status updated successfully';
    } else {
      throw Exception(data['message'] ?? 'Failed to update order status');
    }
  }
}