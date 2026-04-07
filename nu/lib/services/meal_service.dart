import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  // ✅ إضافة وجبة جديدة
  Future<void> addMeal(Meal meal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/meals/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mealName': meal.mealName,
        'mealType': meal.mealType,
        'description': meal.description,
        'protein': meal.protein,
        'carbohydrates': meal.carbohydrates,
        'fat': meal.fat,
        'calories': meal.calories,
        'image': meal.image,
        'providerID': meal.providerID,
      }),
    );
    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to add meal');
    }
  }

  // ✅ تعديل وجبة
  Future<void> updateMeal(int mealID, Meal meal) async {
    final response = await http.put(
      Uri.parse('$baseUrl/meals/update/$mealID'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mealName': meal.mealName,
        'mealType': meal.mealType,
        'description': meal.description,
        'protein': meal.protein,
        'carbohydrates': meal.carbohydrates,
        'fat': meal.fat,
        'calories': meal.calories,
        'image': meal.image,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update meal');
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
      body: jsonEncode({'mealID': mealID, 'pilgrimID': pilgrimID}),
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
  Future<List<Map<String, dynamic>>> getProviderCampaigns(String providerID) async {
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

  // ✅ جلب طلبات المزود (مع فلتر الحملة)
  Future<List<MealOrder>> getOrdersByProvider(String providerID, {String? campaignID}) async {
    final uri = Uri.parse('$baseUrl/orders/provider/$providerID').replace(
      queryParameters: campaignID == null || campaignID.isEmpty ? null : {'campaignID': campaignID},
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

  // ✅ تحديث حالة الطلب (قبول/رفض/توصيل)
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