import 'dart:convert';
import 'dart:developer';
import 'package:patient/data/models/doctorProfile.dart';
import 'package:http/http.dart' as http;
import 'package:patient/data/models/doctor_address.dart';

class DcotorApi {
  // ignore: body_might_complete_normally_nullable
  Future<DoctorProfile?> getDoctorById(int id) async {
    try {
      var url = Uri.parse('https://localhost:44324/api/Doctor/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        DoctorProfile d = DoctorProfile.fromJson(json);
        return d;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<List<DoctorAddress>?> getDoctorWithAddress(
      int specializationId) async {
    try {
      var url = Uri.parse(
          'https://localhost:44324/Doctor/GetDoctorWithAddress/$specializationId');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<DoctorAddress> doctorAddress =
            jsonList.map((json) => DoctorAddress.fromJson(json)).toList();
        return doctorAddress;
      }
    } catch (e) {
      log(e.toString());
    }
  }

}
