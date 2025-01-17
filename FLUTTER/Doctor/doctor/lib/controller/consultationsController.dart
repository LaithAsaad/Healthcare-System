import 'dart:convert';

import 'package:doctor/controller/chatListController.dart';
import 'package:doctor/data/api/doctor_api.dart';
import 'package:doctor/main.dart';
import 'package:get/get.dart';

import '../data/api/message_api.dart';
import '../data/models/chat.dart';
import '../data/models/chatInfo.dart';
import '../data/models/chat_user.dart';

class ConsultationsController extends GetxController {
  ChatListController chatControleer = Get.put(ChatListController());
  List<ChatUsers>? messageList = [];
  ChatInfo? c;

  int? doctorId = sharedPreferences?.getInt('id');

  void getData() async {
    // HubConnection connection = HubConnectionBuilder()
    //     .withUrl("https://localhost:44342/MessageHub")
    //     .build();
    // try {
    //   await connection.start();
    //   print("Connected");
    // } catch (e) {
    //   print('Connection failed: $e');
    // }
    messageList = (await ApiMessageService().getAllQuestionsAvailable());
    await Future.delayed(const Duration(seconds: 1));
    update();
  }

  void ignoreMessage(int index) {
    messageList?.removeAt(index);
    update();
  }

  Future<Chat?> createChat(int patientId, String message) async {
    var response = await DoctorApi().createChat(patientId, doctorId!, message);
    if (response['success'] == true) {
      // Get.showSnackbar(const GetSnackBar(
      //   message: 'Consultation send successful',
      //   duration: Duration(seconds: 3),
      // ));
      return Chat.fromJson(jsonDecode(response['body']));
    }
    return null;
  }

  void deleteMessageAfterAnswer(int id) async {
    var response = await DoctorApi().deleteMessageAfterAnswer(id);
    if (response['success'] == true) {
      // Get.showSnackbar(const GetSnackBar(
      //   message: 'Consultation send successful',
      //   duration: Duration(seconds: 3),
      // ));
    }
  }

  void replyToConsultations(int index, int patientId, String firstName,
      String lastName, String message) async {
    var res = await DoctorApi().replyToConsultations(patientId, doctorId!);

    ChatInfo chatInfo = ChatInfo(
        chatId: res?.id,
        chatUserId: patientId,
        userFirstName: firstName,
        userLastName: lastName,
        userGender: true,
        numberOfUnreadMessage: 0);

    if (chatInfo.chatId == null) {
      Chat? chat = await createChat(chatInfo.chatUserId, message);
      // await DoctorApi().getPatientMessageToChat(chat?.id, message);
      chatInfo.chatId = chat?.id;
    } else {
      await DoctorApi().getPatientMessageToChat(chatInfo.chatId, message);
    }
    deleteMessageAfterAnswer(messageList![index].messageId);
    c = chatInfo;

    for (var item in chatControleer.chatUsersList) {
      if (item.chatId == c?.chatId) {
        item.numberOfUnreadMessage = 0;
      }
    }
    if (chatControleer.checkConnect()) {
      await chatControleer.connection?.start();
    }
    await chatControleer.connection
        ?.invoke("TriggerChatApi", args: [false, c!.chatId.toString()]);
    // chatControleer.offMethodConnection();
    Get.toNamed('/chatDetailPage', arguments: chatInfo)
        ?.then((value) => getData());
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }
}
