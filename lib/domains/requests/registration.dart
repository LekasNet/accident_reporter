import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> register({
  required String login,
  required String password,
  required String phone,
  required String fullName,
  required int drivingExperience,
  required String driverLicense,
}) async {
  final url = Uri.parse('https://accident-reporter.onrender.com/drivers/register');
  final headers = {"Content-Type": "application/json"};
  final body = json.encode({
    "login": login,
    "password": password,
    "phone": phone,
    "full_name": fullName,
    "driving_experience": drivingExperience,
    "driver_license": driverLicense,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      // Успешная регистрация, продолжаем с логином
      print('Registration successful');
      return true;
    } else {
      // Ошибка при регистрации
      print('Failed to register: ${response.body}');
      return false;
    }
  } catch (e) {
    // Обработка исключения при запросе
    print('Error occurred: $e');
    return false;
  }
}
