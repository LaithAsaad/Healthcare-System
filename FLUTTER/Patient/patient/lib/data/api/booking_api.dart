import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:patient/data/models/doctor_booking.dart';

import '../models/booking.dart';

class BookingApi {
  // ignore: body_might_complete_normally_nullable
  Future<List<Booking>?> getAvailableBooking(int doctorId) async {
    try {
      var url = Uri.parse('https://localhost:44324/Booking/GetPatient/$doctorId');
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
  // ignore: body_might_complete_normally_nullable
  Future<List<DoctorBooking>?> getBooking(int patientId) async {
    try {
      var url = Uri.parse('https://localhost:44324/Doctor/GetDoctorWithBooking/$patientId');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<DoctorBooking> a = jsonList.map((json) => DoctorBooking.fromJson(json)).toList();
        return a;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> bookingByPatient(Booking booking) async {
    var url = Uri.parse('https://localhost:44324/Booking/Edit');
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
