import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> login(String login, String password) async {
  final url = Uri.parse('https://accident-reporter.onrender.com/drivers/login');
  final headers = {"Content-Type": "application/json"};
  final body = json.encode({
    "login": login,
    "password": password
  });
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      // Обработка успешного логина
      print('Login successful');
      // Получаем accessToken из тела ответа
      var data = json.decode(response.body);
      var accessToken = data['accessToken'];
      print(accessToken);

      // Сохраняем accessToken в SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);

      return true;
    } else {
      // Обработка ошибки логина
      print('Failed to login: ${response.body}');
      return false;
    }
  } catch (e) {
    // Обработка исключения при запросе
    print('Error occurred: $e');
    return false;
  }
}
