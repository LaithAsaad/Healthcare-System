import 'dart:convert';
import 'dart:developer';
import 'package:patient/data/models/address.dart';
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
}
