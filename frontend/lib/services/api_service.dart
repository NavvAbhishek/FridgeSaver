import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/inventory_item_model.dart';

class ApiService {
  // Use localhost for web/iOS simulator, 10.0.2.2 for Android emulator
  static const String _baseUrl = "http://localhost:8080/api";

  // Helper method to get headers with the auth token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // --- Inventory Methods ---

  static Future<List<InventoryItem>> getInventoryItems() async {
    final headers = await _getHeaders();
    final response =
        await http.get(Uri.parse('$_baseUrl/inventory'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<InventoryItem> items =
          body.map((dynamic item) => InventoryItem.fromJson(item)).toList();
      return items;
    } else {
      throw Exception('Failed to load inventory items');
    }
  }

  static Future<InventoryItem> addItem(
      {required String name,
      required int quantity,
      required String expiryDate}) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/inventory'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'quantity': quantity,
        'expiryDate': expiryDate, // Expects "YYYY-MM-DD"
      }),
    );

    if (response.statusCode == 200) {
      return InventoryItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add item');
    }
  }

  static Future<void> deleteItem(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$_baseUrl/inventory/$id'),
        headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }
}
