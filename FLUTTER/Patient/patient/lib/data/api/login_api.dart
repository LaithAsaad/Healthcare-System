import 'dart:convert';

import 'package:patient/data/models/login.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  Future<Map<String, dynamic>> loginPatient(LogInModel logInModel) async {
    var url = Uri.parse('https://localhost:44324/login/patient');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(logInModel.toJson()),
    );

    if (response.statusCode == 200) {
      // Login successful
      return {
        "success": true,
        "body": response.body,
      };
    } else if (response.statusCode == 400) {
      // Login failed
      final error = jsonDecode(response.body)['error'];
      return {
        "success": false,
        "error": error,
      };
    } else {
      // Unexpected error
      return {
        "success": false,
        "error": "Unexpected error: ${response.statusCode}",
      };
    }
  }
}
