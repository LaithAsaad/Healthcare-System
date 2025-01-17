import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../data/api/chat_api.dart';
import '../data/api/patient_api.dart';
import '../data/models/chat.dart';
import '../data/models/message.dart';
import '../main.dart';
import 'package:path/path.dart' as path;

class ChatMessageController extends GetxController {
  final messages = <Message>[].obs;
  final message2 = <Message>[].obs;
  final textEditingController = TextEditingController();
  final scrollController = ScrollController();
  int? patientId = sharedPreferences?.getInt('id');

  late bool editing = false;
  late int messageIndex = 0;
  HubConnection connection = HubConnectionBuilder()
      .withUrl("https://localhost:44324/MessageHub")
      .withAutomaticReconnect()
      .build();

  void triggerServer(bool isPatient, int id) {
    connection.invoke("TriggerApi", args: [isPatient, id.toString()]);
  }

  void getData() async {
    try {
      if (connection.state == HubConnectionState.Disconnected) {
        await connection.start();
      }
      print("Connected");

      addMessage();
      addedMessage();
      deleteMessageHub();
      updateMessage();
      updateStatus();
    } catch (e) {
      print('Connection failed: $e');
    }
    print("before get list");
    if (Get.arguments.chatId != null) {
      message2.value =
          (await ApiChatService().getPatientMessages(Get.arguments.chatId)) ??
              [];
    }
    // if (message2.isNotEmpty) {
    //   await Future.delayed(const Duration(seconds: 1));

    //   message2.value = message2.reversed.toList();
    // }
    print("after get list");
    updateRead();
    // for(var m in message2){
    //   if(m.isRead==false){
    //     m.isRead=true;
    //   }
    // }
    // message2.refresh();
  }

  void getFirstMessage() async {
    if (Get.arguments.chatId != null) {
      message2.value =
          (await ApiChatService().getPatientMessages(Get.arguments.chatId))!;
    }
    if (message2.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1));

      message2.value = message2.reversed.toList();
    }
  }

  void deleteMessage(Message message, List<Message> list) async {
    messages.value =
        (await ApiChatService().deletePatientMessage(message, list))!;
    message2.value = List.from(messages);
    message2.refresh();
  }

  void addMessage() {
    connection.on("addMessage", (message) {
      // print("New message: $message");

      List<Message>? messageList = message
          ?.map<Message>(
              (item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();
      if (messageList?.last.chatId == Get.arguments.chatId) {
        for (var element in messageList!) {
          print("element $element");
          element.date = element.date.add(const Duration(hours: 3));
        }
        message2.insertAll(0, messageList);
      }
    });
  }

  void addedMessage() {
    connection.on("addedMessage", (message) {
      // print("Added message: $message");

      List<Message>? messageList = message
          ?.map<Message>(
              (item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();
      if (messageList!.last.byPatient == false &&
          messageList.last.chatId == Get.arguments.chatId) {
        print("ok");
        if (connection.state == HubConnectionState.Connected) {
          print("Connected");
          triggerServer(true, messageList.last.id!);
        }
      } else {
        print("ok by patient");
      }
    });
  }

  void deleteMessageHub() {
    connection.on("deleteMessageHub", (message) {
      // print("Received message: $message");

      List<Message>? messageList = message
          ?.map<Message>(
              (item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();

      for (var element in message2) {
        if (element.chatId == messageList?.last.chatId &&
            element.id == messageList?.last.id &&
            messageList?.last.chatId == Get.arguments.chatId) {
          message2.remove(element);
        }
      }
    });
  }

  void updateMessage() {
    try {
      connection.on("updateMessage", (message) {
        // print("Received message: $message");
        // print("message");

        List<Message>? messageList = message
            ?.map<Message>(
                (item) => Message.fromJson(item as Map<String, dynamic>))
            .toList();
        for (var element in message2) {
          if (element.id == messageList?.last.id &&
              messageList?.last.chatId == Get.arguments.chatId) {
            print("this message will updated ${element.messageContent}");
            element.messageContent = messageList!.last.messageContent;
            element.date = messageList.last.date.add(Duration(hours: 3));
            element.isEdited = true;
          }
          message2.refresh();
        }
      });
    } catch (e) {
      print('Connection failed test sockect error: $e');
    }
  }

  void updateStatus() {
    try {
      connection.on("updateStatus", (message) {
        // print("updateStatus message: $message");

        if (message?[0] != null) {
          List<Message>? messageList = message
              ?.map<Message>(
                  (item) => Message.fromJson(item as Map<String, dynamic>))
              .toList();
          for (var element in message2) {
            if (element.id == messageList?.last.id &&
                messageList?.last.byPatient == true &&
                messageList?.last.chatId == Get.arguments.chatId) {
              element.isRead = messageList?.last.isRead;
            }
          }
          message2.refresh();
        }
      });
    } catch (e) {
      print('Connection failed test sockect error: $e');
    }
  }

  void updateRead() {
    connection.on("update", (message) {
      List list = message?[0] as List;
      List<Message>? messageList = list
          .map<Message>(
              (item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();
      for (var element in messageList) {
        for (var item in message2) {
          if (element.id == item.id &&
              messageList.last.chatId == Get.arguments.chatId) {
            print(
                "this message will update it status ${element.messageContent}");

            item.isRead = element.isRead;
            print(element.isRead);
            print(item.isRead);
          }
        }
      }
      message2.refresh();
    });
  }

  void editMessage(String content, int index) {
    textEditingController.text = content;
    editing = true;
    messageIndex = index;
  }

  void clearText() {
    textEditingController.clear();
  }

  // ignore: body_might_complete_normally_nullable
  Future<Chat?> createChat(int doctorId, String message) async {
    var response = await PatientApi().createChat(patientId!, doctorId, message);
    if (response['success'] == true) {
      // Get.showSnackbar(const GetSnackBar(
      //   message: 'Consultation send successful',
      //   duration: Duration(seconds: 3),
      // ));
      return Chat.fromJson(jsonDecode(response['body']));
    }
  }

  void pickAndMoveImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      String appDirPath = 'F:\\fourth year Project\\chatImages';
      // Move the image to the desired folder
      await File(pickedImage.path)
          .copy('$appDirPath\\${path.basename(pickedImage.path)}');

      await Future.delayed(const Duration(seconds: 5));
      String imageName = "~~~${pickedImage.name}";
      
      PatientApi().sendMessage(Get.arguments.chatId, imageName);
      // doctor?.image = imageName;
    }
  }

  bool checkMessageLength(int index) {
    if (message2[index].messageContent.length >= 3 &&
        message2[index].messageContent.substring(0, 3) == '~~~') {
      return false;
    } else {
      return true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onClose() {
    // Disconnect the SignalR connection when closing the controller
    connection.stop();
    print('connect stop');
    super.onClose();
  }
}
