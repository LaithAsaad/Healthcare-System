import 'dart:convert';
import 'dart:developer';
import 'package:patient/data/models/chat.dart';
import 'package:patient/data/models/message.dart';
import 'package:patient/data/models/patientProfile.dart';
import 'package:http/http.dart' as http;

class PatientApi {
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

  Future<Map<String, dynamic>> editPatient(
      PatientProfile patientProfile) async {
    var url = Uri.parse('https://localhost:44324/Patient/edit');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(patientProfile.toJson()),
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
        "https://localhost:44324/api/Patient/UpdateMessage?id=$id&content=$content");
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

  Future<List<Message>?> getAllConsultation(int id) async {
  try {
    var url = Uri.parse('https://localhost:44324/Patient/getAllConsultation/$id');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List<dynamic>;
      List<Message> specList = jsonList.map((json) => Message.fromJson(json)).toList();
      return specList;
    }
  } catch (e) {
    log(e.toString());
  }
  
  return null; // Return null in case of failure
}

  Future<Map<String, dynamic>> sendConsultation(
      Message message, int patientId) async {
    var url = Uri.parse(
        'https://localhost:44324/Patient/sendConsultation/$patientId');
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(message.toJson()),
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

  // ignore: body_might_complete_normally_nullable
  Future<Chat?> sendMessageToDoctor(int patientId, int doctorId) async {
    var url = Uri.parse(
        'https://localhost:44324/Patient/sendMessageToDoctor/$patientId/$doctorId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      Chat chat = Chat.fromJson(json);
      return chat;
    } else if (response.statusCode == 204) {
      return null; // Handle the case when the chat is not found
    }
  }

  Future<Map<String, dynamic>> createChat(int patientId, int doctorId,String message) async {
    var url = Uri.parse(
        'https://localhost:44324/Patient/createChat/$patientId/$doctorId/$message');
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
