import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../models/booking.dart';

class BookingApi {
  // ignore: body_might_complete_normally_nullable
  Future<List<Booking>?> getBookingByDoctorId(int doctorId) async {
    try {
      var url = Uri.parse('https://localhost:44324/Booking/GetDcotor/$doctorId');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<Booking> a = jsonList.map((json) => Booking.fromJson(json)).toList();
        return a;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> addBooking(Booking booking) async {
    var url = Uri.parse('https://localhost:44324/Booking/Add');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(booking.toJson()),
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

  Future<Map<String, dynamic>> deleteBooking(Booking booking) async {
    var url = Uri.parse('https://localhost:44324/Booking/Delete');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(booking.toJson()),
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
