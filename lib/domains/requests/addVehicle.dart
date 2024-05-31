import 'package:http/http.dart' as http;
import 'dart:convert';

/// Отправляет данные транспортного средства на сервер.
Future<void> addVehicle({
  required String brand,
  required String model,
  required String bodyType,
  required String regNumber,
}) async {
  final url = Uri.parse('https://yourapi.com/drivers/add-vehicle');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'brand': brand,
    'model': model,
    'body_type': bodyType,
    'reg_number': regNumber,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Vehicle added successfully.');
    } else {
      print('Failed to add vehicle. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while sending request: $e');
  }
}
