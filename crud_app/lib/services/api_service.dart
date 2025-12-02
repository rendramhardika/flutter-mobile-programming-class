import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/';
  static const String endpoint = '/posts';

  // CREATE
  Future<ItemModel> create(ItemModel item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return ItemModel.fromJson(json);
      } else {
        throw Exception('Failed to create item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating item: $e');
    }
  }

  // READ ALL
  Future<List<ItemModel>> readAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => ItemModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading items: $e');
    }
  }

  // READ ONE
  Future<ItemModel> readOne(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/$id'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ItemModel.fromJson(json);
      } else {
        throw Exception('Failed to load item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading item: $e');
    }
  }

  // UPDATE
  Future<ItemModel> update(ItemModel item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint/${item.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ItemModel.fromJson(json);
      } else {
        throw Exception('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating item: $e');
    }
  }

  // DELETE
  Future<void> delete(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting item: $e');
    }
  }
}
