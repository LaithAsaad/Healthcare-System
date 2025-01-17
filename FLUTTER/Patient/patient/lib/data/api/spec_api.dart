import 'dart:convert';
import 'dart:developer';
import 'package:patient/data/models/specialization.dart';
import 'package:http/http.dart' as http;

class SpecializationApi {
  // ignore: body_might_complete_normally_nullable
  Future<List<Specialization>?> getAllSpecAvailable() async {
    try {
      var url = Uri.parse('https://localhost:44324/api/Specialization') ;
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<Specialization> specList = jsonList.map((json) => Specialization.fromJson(json)).toList();
        return specList;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Specialization?> getSpecializationById(int id) async {
    try {
      var url = Uri.parse('https://localhost:44324/Specialization/Get/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        Specialization spec = Specialization.fromJson(json);
        return spec;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
