import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../data/api/chat_api.dart';
import '../data/api/doctor_api.dart';
import '../data/models/message.dart';
import '../main.dart';
import 'package:path/path.dart' as path;

class ChatMessageController extends GetxController {
  final messages = <Message>[].obs;
  final message2 = <Message>[].obs;
  final textEditingController = TextEditingController();
  final scrollController = ScrollController();
  int? doctorId = sharedPreferences?.getInt('id');
  late bool editing = false;
  late int messageIndex = 0;
  final connection = HubConnectionBuilder()
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
      deleteMessageHub();
      addedMessage();
      updateMessage();
      updateStatus();
    } catch (e) {
      print('Connection failed: $e');
    }
    print("before get list");
    message2.value =
        await ApiChatService().getDoctorMessages(Get.arguments.chatId) ?? [];
    // if (message2.isNotEmpty) {
    //   await Future.delayed(const Duration(seconds: 1));

    //   message2.value = message2.reversed.toList();
    // }
    print("after get list");
    updateRead();
  }

  void getFirstMessage() async {
    if (Get.arguments.chatId != null) {
      message2.value =
          (await ApiChatService().getDoctorMessages(Get.arguments.chatId)) ??
              [];
    }
    if (message2.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1));

      message2.value = message2.reversed.toList();
    }
  }

  void deleteMessage(Message message, List<Message> list) async {
    messages.value =
        (await ApiChatService().deleteDoctorMessage(message, list))!;
    message2.value = List.from(messages);
    message2.refresh();
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
            element.id == messageList?.last.id) {
          message2.remove(element);
        }
      }
      message2.refresh();
    });
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
      if (messageList!.last.byPatient == true &&
          messageList.last.chatId == Get.arguments.chatId) {
        print("ok");
        if (connection.state == HubConnectionState.Connected) {
          print("Connected");
          triggerServer(false, messageList.last.id!);
        }
      } else {
        print("ok by patient");
      }
      message2.refresh();
    });
  }

  void updateMessage() {
    connection.on("updateMessage", (message) {
      // print("Received message: $message");

      List<Message>? messageList = message
          ?.map<Message>(
              (item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();
      for (var element in message2) {
        if (element.id == messageList?.last.id &&
            messageList?.last.chatId == Get.arguments.chatId) {
          print("this message will updated ${element.messageContent}");
          element.messageContent = messageList!.last.messageContent;
          element.date = messageList.last.date.add(const Duration(hours: 3));
          element.isEdited = true;
        }
      }
      message2.refresh();
    });
  }

  void updateStatus() {
    connection.on("updateStatus", (message) {
      // print("updateStatus message: $message");

      if (message?[0] != null) {
        List<Message>? messageList = message
            ?.map<Message>(
                (item) => Message.fromJson(item as Map<String, dynamic>))
            .toList();
        for (var element in message2) {
          if (element.id == messageList?.last.id &&
              messageList?.last.byPatient == false &&
              messageList?.last.chatId == Get.arguments.chatId) {
            print(
                "this message will update it status ${element.messageContent}");

            element.isRead = messageList?.last.isRead;
            print(element.isRead);
            print(messageList?.last.isRead);
          }
        }
      }
      message2.refresh();
    });
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

      DoctorApi().sendMessage(Get.arguments.chatId, imageName);
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

  void clearText() {
    textEditingController.clear();
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
