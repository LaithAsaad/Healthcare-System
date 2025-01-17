import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dcotor.dart';

class RegisterApi {
  Future<Map<String, dynamic>> registerDoctor(Doctor doctor) async {
    var url = Uri.parse('https://localhost:44324/reg/doctor');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(doctor.toJson()),
    );

    if (response.statusCode == 200) {
      // Login successful
      return {
        "success": true,
        "body": response.body,
      };
    } else if (response.statusCode == 400) {
      var message = jsonDecode(response.body);
      // Login failed
      if (message.containsKey('description')) {
        return {
          "success": false,
          "error": message['description'],
        };
        // Handle error with description property
      } else {
        return {
          "success": false,
          "error": message['error'],
        };
        // Handle error with error property
      }
    } else {
      // Unexpected error
      return {
        "success": false,
        "error": "Unexpected error: ${response.statusCode}",
      };
    }
  }
}
