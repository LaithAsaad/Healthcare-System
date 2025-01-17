import 'dart:convert';
import 'dart:developer';
import 'package:doctor/data/models/patientProfile.dart';
import 'package:http/http.dart' as http;


class PatientApi{
  // ignore: body_might_complete_normally_nullable
  Future<PatientProfile?> getPatientById(int id) async {
    try {
      var url = Uri.parse('https://localhost:44324/api/Patient/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        PatientProfile d = PatientProfile.fromJson(json);
        return d;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
