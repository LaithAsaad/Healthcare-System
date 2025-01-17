import 'dart:convert';
import 'dart:developer';
import 'package:doctor/data/models/doctorProfile.dart';
import 'package:http/http.dart' as http;

import '../models/chat.dart';

class DoctorApi {
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

  Future<Map<String, dynamic>> editDoctor(DoctorProfile doctorProfile) async {
    var url = Uri.parse('https://localhost:44324/Doctor/edit');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(doctorProfile.toJson()),
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

  Future<Map<String, dynamic>> sendMessage(id, content) async {
    var url = Uri.parse(
        "https://localhost:44324/api/Doctor/SendMessage?id=$id&content=$content");
    var response = await http.post(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return {
        "success": true,
        "body": response.body,
      };
    } else if (response.statusCode == 400) {
      var message = jsonDecode(response.body);
      return {
        "success": false,
        "error": message['error'],
      };
    } else {
      // Unexpected error
      return {
        "success": false,
        "error": "Unexpected error: ${response.statusCode}",
      };
    }
  }

  Future<Map<String, dynamic>> getPatientMessageToChat(id, content) async {
    var url = Uri.parse(
        "https://localhost:44324/api/Patient/SendMessage?id=$id&content=$content");
    var response = await http.post(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return {
        "success": true,
        "body": response.body,
      };
    } else if (response.statusCode == 400) {
      var message = jsonDecode(response.body);
      return {
        "success": false,
        "error": message['error'],
      };
    } else {
      // Unexpected error
      return {
        "success": false,
        "error": "Unexpected error: ${response.statusCode}",
      };
    }
  }

  Future<Map<String, dynamic>> updateMessage(id, content) async {
    var url = Uri.parse(
        "https://localhost:44324/api/Doctor/UpdateMessage?id=$id&content=$content");
    var response = await http.post(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return {
        "success": true,
        "body": response.body,
      };
    } else if (response.statusCode == 400) {
      var message = jsonDecode(response.body);
      return {
        "success": false,
        "error": message['error'],
      };
    } else {
      // Unexpected error
      return {
        "success": false,
        "error": "Unexpected error: ${response.statusCode}",
      };
    }
  }

  Future<Chat?> replyToConsultations(int patientId, int doctorId) async {
    var url = Uri.parse(
        'https://localhost:44324/Doctor/sendMessageToDoctor/$patientId/$doctorId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      Chat chat = Chat.fromJson(json);
      return chat;
    } else if (response.statusCode == 204) {
      return null; // Handle the case when the chat is not found
    }
    return null;
  }

  Future<Map<String, dynamic>> createChat(int patientId, int doctorId,String message) async {
    var url = Uri.parse(
        'https://localhost:44324/Doctor/createChat/$patientId/$doctorId/$message');
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
  Future<Map<String, dynamic>> deleteMessageAfterAnswer(int id) async {
    var url = Uri.parse(
        'https://localhost:44324/Doctor/DeleteMessageAfterAnswer/$id');
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
