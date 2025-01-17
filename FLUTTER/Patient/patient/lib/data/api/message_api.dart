import 'dart:convert';
import 'dart:developer';
import 'package:patient/data/models/chat_user.dart';
import 'package:http/http.dart' as http;

class ApiMessageService {
  // ignore: body_might_complete_normally_nullable
  Future<List<ChatUsers>?> getAllQuestionsAvailable() async {
    try {
      var url = Uri.parse(
          "https://localhost:44324/api/Doctor/GetQuestions");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body) as List<dynamic>;
        List<ChatUsers> messageList =
            jsonList.map((json) => ChatUsers.fromJson(json)).toList();
        return messageList;
      }
    } catch (e) {
      print('fngfng,mngf,');
      log(e.toString());
    }
  }
}
