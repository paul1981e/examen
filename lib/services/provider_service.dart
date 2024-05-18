import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/provider.dart';

class ProviderService with ChangeNotifier {
  final String _baseUrl = "http://143.198.118.203:8050";
  final String _user = "test";
  final String _pass = "test2023";

  Future<ProviderList> getProviderList() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/ejemplos/provider_list_rest/'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return ProviderList.fromJson(response.body);
    } else {
      throw Exception('Failed to load provider list');
    }
  }

  Future<void> addProvider(Map<String, String> providerData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ejemplos/provider_add_rest/'),
      headers: _getHeaders(),
      body: jsonEncode(<String, String>{
        'provider_name': providerData['providerName'] ?? '',
        'provider_last_name': providerData['providerLastName'] ?? '',
        'provider_mail': providerData['providerMail'] ?? '',
        'provider_state': providerData['providerState'] ?? '',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add provider');
    }

    notifyListeners();
  }

  Future<void> editProvider(int providerId, String newName, String newLastName, String newMail, String newState) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ejemplos/provider_edit_rest/'),
      headers: _getHeaders(),
      body: jsonEncode(<String, dynamic>{
        'provider_id': providerId,
        'provider_name': newName,
        'provider_last_name': newLastName,
        'provider_mail': newMail,
        'provider_state': newState,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit provider');
    }

    notifyListeners();
  }

  Future<void> deleteProvider(int providerId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ejemplos/provider_del_rest/'),
      headers: _getHeaders(),
      body: jsonEncode(<String, dynamic>{
        'provider_id': providerId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete provider');
    }

    notifyListeners();
  }

  Map<String, String> _getHeaders() {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));
    return {'authorization': basicAuth, 'Content-Type': 'application/json; charset=UTF-8'};
  }
}
