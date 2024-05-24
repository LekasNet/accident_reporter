import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/globals.dart';


Future<void> fetchVehicles() async {
  final url = Uri.parse('https://accident-reporter.onrender.com/drivers/vehicles');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken'); // Получение сохраненного токена

  if (accessToken == null) {
    print("No access token available.");
    return;
  }

  final headers = {
    "Content-Type": "application/json",
    "Authorization": accessToken
  };

  try {
    final response = await http.get(url, headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> vehicles = json.decode(response.body)["data"];
      items = vehicles.map((vehicle) {
        return Item(
          icon: getRandomIcon(),  // Случайный выбор иконки пока не реализован
          title: vehicle['reg_number'],
          description: "${vehicle['brand']} ${vehicle['model']} (${vehicle['body_type']})",
        );
      }).toList();
      print('Vehicles fetched successfully');
    } else {
      print('Failed to fetch vehicles: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while fetching vehicles: $e');
  }
}
