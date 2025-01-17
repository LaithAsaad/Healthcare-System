import 'dart:convert';
import 'dart:developer';
import 'package:doctor/data/models/chat.dart';
import 'package:http/http.dart' as http;

import '../models/chatInfo.dart';
import '../models/message.dart';

class ApiChatService {
  // ignore: body_might_complete_normally_nullable
  Future<List<Chat>?> getAllChatAvailable() async {
    try {
      var url = Uri.parse(
          "https://localhost:44324/api/Chat/getChats");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<Chat> chatList =
            jsonList.map((json) => Chat.fromJson(json)).toList();
        return chatList;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<List<ChatInfo>?> getPatientChats(id) async {
    try {
      var url = Uri.parse(
          "https://localhost:44324/api/Patient/GetChats/$id");
      var response = await http.get(url);
      //print(response.statusCode);

      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<ChatInfo> chatList =
            jsonList.map((json) => ChatInfo.fromJson(json)).toList();
        print(chatList.first.lastMessageDate);
        print(chatList.first.numberOfUnreadMessage);
        return chatList;
      }
    } catch (e) {
      log(e.toString());
    }
  }


  // ignore: body_might_complete_normally_nullable
  Future<List<ChatInfo>?> getDoctorChats(id) async {
    try {
      var url = Uri.parse(
          "https://localhost:44324/api/Doctor/GetChats/$id");
      var response = await http.get(url);
      //print(response.statusCode);

      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<ChatInfo> chatList =
            jsonList.map((json) => ChatInfo.fromJson(json)).toList();
        print(chatList.first.lastMessageDate);
        print(chatList.first.numberOfUnreadMessage);
        chatList.sort((a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),);
        return chatList;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<List<Message>?> getPatientMessages(id) async {
    try {
      var url = Uri.parse(
          "https://localhost:44324/api/Patient/GetMessages/$id");
      var response = await http.get(url);
      print("getPatientMessages said: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<Message> messageList =
            jsonList.map((json) => Message.fromJson(json)).toList();
        return messageList;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<List<Message>?> getDoctorMessages(id) async {
    try {
      var url = Uri.parse(
          "https://localhost:44324/api/Doctor/GetMessages/$id");
      var response = await http.get(url);
      print("getPatientMessages said: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<Message> messageList =
            jsonList.map((json) => Message.fromJson(json)).toList();
        return messageList.reversed.toList();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<List<Message>?> deletePatientMessage(
      Message message, List<Message> list) async {
    try {
      var url = Uri.parse(
          "https://localhost:44324/api/Patient/DeleteMessage/${message.id}");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print("message deleted");
        list.remove(message);
      } else if (response.statusCode == 405) {
        print("Method Not Allowed");
      } else {
        print("Delete failed");
      }
      return list;
    } catch (e) {
      log(e.toString());
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<List<Message>?> deleteDoctorMessage(
      Message message, List<Message> list) async {
    try {
      var url = Uri.parse(
          "https://localhost:44324/api/Doctor/DeleteMessage/${message.id}");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print("message deleted");
        list.remove(message);
      } else if (response.statusCode == 405) {
        print("Method Not Allowed");
      } else {
        print("Delete failed");
      }
      return list;
    } catch (e) {
      log(e.toString());
    }
  }
}
