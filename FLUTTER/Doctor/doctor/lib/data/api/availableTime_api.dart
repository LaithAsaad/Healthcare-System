import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/availableTime.dart';

class AvailableTimeApi {
  // ignore: body_might_complete_normally_nullable
  Future<List<AvailableTime>?> getAllAvailabeTime(int doctorId) async {
    try {
      var url =
          Uri.parse('https://localhost:44324/Doctor/getAvailable/$doctorId');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<AvailableTime> specList =
            jsonList.map((json) => AvailableTime.fromJson(json)).toList();
        return specList;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> addAvailableTime(
      AvailableTime availableTime) async {
    var url = Uri.parse('https://localhost:44324/Doctor/addAvailable');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(availableTime.toJson()),
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
      return {
        "success": false,
        "error": message['error'],
        // Handle error with error property
      };
    } else {
      // Unexpected error
      return {
        "success": false,
        "error": "Unexpected error: ${response.statusCode}",
      };
    }
  }

  Future<Map<String, dynamic>> deleteAvailableTime(int id) async {
    var url = Uri.parse('https://localhost:44324/Doctor/deleteAvailable/$id');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
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
      return {
        "success": false,
        "error": message['error'],
        // Handle error with error property
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
