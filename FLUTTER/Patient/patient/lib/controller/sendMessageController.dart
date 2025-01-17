import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient/data/api/patient_api.dart';
import 'package:patient/data/models/chatInfo.dart';
import 'package:patient/main.dart';

import '../data/models/message.dart';

class SendMessageController extends GetxController {
  late List<Message> messages = [];
  TextEditingController messageController = TextEditingController();
  int? patientId = sharedPreferences?.getInt('id');

  void getAllConsultation() async {
    messages = (await PatientApi().getAllConsultation(patientId!)) ??
        []; // Provide an empty list as a default value if the result is null
    update();
  }

  void sendConsultation(Message message) async {
    var response = await PatientApi().sendConsultation(message, patientId!);
    if (response['success'] == true) {
      Get.showSnackbar(const GetSnackBar(
        message: 'Consultation send successful',
        duration: Duration(seconds: 3),
      ));
      messages.add(Message.fromJson(jsonDecode(response['body'])));
    } else {
      // Display error message
      // Get.defaultDialog(
      //   confirm: TextButton(
      //     onPressed: () => Get.back(),
      //     child: Text('OK'),
      //   ),
      //   titlePadding: EdgeInsets.only(top: 20),
      //   contentPadding: EdgeInsets.all(20),
      //   titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      //   title: 'Error!',
      //   content: Text('${response['error']}'),
      //);
    }
    update();
  }

  // void addToPage(Message message){
  //   messages?.add(message);
  //   update();
  // }

  void sendMessageToDoctor(
      int doctorId, String firstName, String lastName, String? image) async {
    var res = await PatientApi().sendMessageToDoctor(patientId!, doctorId);
    // Get.showSnackbar(const GetSnackBar(
    //   message: 'Consultation send successful',
    //   duration: Duration(seconds: 3),
    // ));
    // var res = Chat.fromJson(jsonDecode(response['body']));
    ChatInfo chatInfo = ChatInfo(
        chatId: res?.id,
        chatUserId: doctorId,
        userFirstName: firstName,
        userLastName: lastName,
        userImage: image,
        userGender: true);
    Get.toNamed('/chatDetailPage', arguments: chatInfo);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getAllConsultation();
  }
}
