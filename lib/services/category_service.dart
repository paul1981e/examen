import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/category.dart';

class CategoryService extends ChangeNotifier {
  final String _baseUrl = "http://143.198.118.203:8050";
  final String _user = "test";
  final String _pass = "test2023";

  Future<CategoryList> getCategoryList() async {
    final response = await http.get(Uri.parse('$_baseUrl/ejemplos/category_list_rest/'), headers: _getHeaders());
    print(response.body);
    if (response.statusCode == 200) {
      return CategoryList.fromJson(response.body);
    } else {
      throw Exception('Failed to load category list $Error');
    }
  }

  Future<void> addCategory(Category category) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/ejemplos/category_add_rest/'),
    headers: _getHeaders(),
    body: jsonEncode(<String, dynamic>{
      'category_name': category.categoryName,
      'category_state': category.categoryState,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add category');
  }
}


  Future<void> editCategory(int categoryId, String newName, String newState) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ejemplos/category_edit_rest/'),
      headers: _getHeaders(),
      body: jsonEncode(<String, dynamic>{
        'category_id': categoryId,
        'category_name': newName,
        'category_state': newState,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit category');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ejemplos/category_del_rest/'),
      headers: _getHeaders(),
      body: jsonEncode(<String, dynamic>{
        'category_id': categoryId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }

  Map<String, String> _getHeaders() {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));
    return {'authorization': basicAuth, 'Content-Type': 'application/json; charset=UTF-8'};
  }
}
