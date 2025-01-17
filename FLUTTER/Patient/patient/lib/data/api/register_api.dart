import 'dart:convert';
import 'package:patient/data/models/patient.dart';
import 'package:http/http.dart' as http;

class RegisterApi {
  Future<Map<String, dynamic>> registerPatient(Patient patient) async {
    var url = Uri.parse('https://localhost:44324/api/Patient');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(patient.toJson()),
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
