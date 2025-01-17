import 'dart:convert';
import 'dart:developer';
import 'package:doctor/data/models/address.dart';
import 'package:http/http.dart' as http;

class AddressApi {
  // ignore: body_might_complete_normally_nullable
  Future<Address?> getAddressById(int id) async {
    try {
      var url = Uri.parse('https://localhost:44324/api/Address/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        Address a = Address.fromJson(json);
        return a;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> addAddress(Address address) async {
    var url = Uri.parse('https://localhost:44324/api/Address');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(address.toJson()),
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
