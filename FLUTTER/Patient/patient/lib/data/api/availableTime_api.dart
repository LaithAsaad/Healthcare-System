import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/availableTime.dart';

class AvailableTimeApi{

  // ignore: body_might_complete_normally_nullable
  Future<List<AvailableTime>?> getAllAvailabeTime(int doctorId) async {
    try {
      var url = Uri.parse('https://localhost:44324/Doctor/getAvailable/$doctorId') ;
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<AvailableTime> specList = jsonList.map((json) => AvailableTime.fromJson(json)).toList();
        return specList;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}