import 'package:get/get.dart';
import 'package:patient/data/models/message.dart';
import 'package:patient/main.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../data/api/chat_api.dart';
import '../data/models/chatInfo.dart';

class ChatListController extends GetxController {
  RxList<ChatInfo> chatUsersList = <ChatInfo>[].obs;
  HubConnection? connection;
  int? patientId = sharedPreferences?.getInt('id');

  void getData() async {
    try {
      print("Connected");
      addMessage();
      deleteMessage();
      updateMessage();
      getCreatedChat();
      getCreatedChat();
    } catch (e) {
      print('Connection failed: $e');
    }

    getChatMessages();

    print("Good until here");
    chatUsersList.value =
        (await ApiChatService().getPatientChats(patientId)) ?? [];
    await Future.delayed(const Duration(seconds: 1));
  }

  void addMessage() {
    connection?.on("addMessage", (message) async {
      Message messageList =
          Message.fromJson(message?.last as Map<String, dynamic>);

      for (var element in chatUsersList) {
        if (element.chatId == messageList.chatId) {
          element.userLastMessage = messageList.messageContent;
          element.lastMessageDate = messageList.date;
          if (messageList.byPatient == false && messageList.isRead == false) {
            element.numberOfUnreadMessage =
                (element.numberOfUnreadMessage! + 1);
          }
        }
      }
      chatUsersList.sort(
        (a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),
      );
    });
  }

  void deleteMessage() {
    connection?.on("deleteMessage", (message) {
      //print("Received message: $message");

      Message messageList =
          Message.fromJson(message?.last as Map<String, dynamic>);

      for (var element in chatUsersList) {
        if (element.chatId == messageList.chatId) {
          element.userLastMessage = messageList.messageContent;
          if (messageList.byPatient == true) {
            element.numberOfUnreadMessage = 0;
          } else if (messageList.isRead == true) {
            element.numberOfUnreadMessage = 0;
          } else {
            element.numberOfUnreadMessage =
                (element.numberOfUnreadMessage! - 1);
          }
        }
      }
      chatUsersList.sort(
        (a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),
      );
    });
  }

  void updateMessage() {
    connection?.on("updateMessage", (message) {
      // print("Received message: $message");
      // print("chat update");

      Message messageList =
          Message.fromJson(message?.last as Map<String, dynamic>);
      for (var element in chatUsersList) {
        if (element.chatId == messageList.chatId) {
          element.userLastMessage = messageList.messageContent;
          element.lastMessageDate = messageList.date;
        }
      }
      chatUsersList.sort(
        (a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),
      );
    });
  }

  void getChatMessages() {
    connection?.on("getChatMessages", (message) {
      // print("Received message: $message");
      // print("chat");

      List<Message>? messageList = message
          ?.map<Message>(
              (item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();
      print("last message ${messageList?.last.messageContent}");
      print("last message ${messageList?.first.messageContent}");
      for (var element in chatUsersList) {
        if (element.chatId == messageList?.last.chatId) {
          element.userLastMessage = messageList!.last.messageContent;
          element.lastMessageDate = messageList.last.date;
          print(element.userLastMessage);
        }
      }
      chatUsersList.sort(
        (a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),
      );
    });
  }

  // void getCreatedChat() {
  //   connection?.on("getCreatedChat", (message, id) async {
  //     ChatInfo messageList =
  //         ChatInfo.fromJson(message?.last as Map<String, dynamic>);
  //     chatUsersList.insert(0, messageList);
  //     chatUsersList.sort(
  //       (a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),
  //     );
  //   });
  // }
  void getCreatedChat() {
    connection?.on("getCreatedChat", (args) {
      var message = args?[0];
      var id = args?[1];

      if (id == patientId) {
        ChatInfo messageList =
            ChatInfo.fromJson(message as Map<String, dynamic>);
        messageList.numberOfUnreadMessage = 0;
        var isInserted =
            chatUsersList.firstWhereOrNull((element) => element.chatId == messageList.chatId);
        if (isInserted == null) {
          chatUsersList.insert(0, messageList);
          chatUsersList.sort(
            (a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),
          );
        }
      }
    });
  }

  String checkImageMessage(String image) {
    if (image.length < 3) {
      return image;
    } else if (image.substring(0, 3) == '~~~') {
      return 'Photo';
    } else if (image.length < 30) {
      return image;
    } else {
      return "${image.substring(0, 30)}....";
    }
  }

  void offMethodConnection() {
    connection?.off("addMessage");
    connection?.off("deleteMessage");
    connection?.off("updateMessage");
    connection?.off("getChatMessages");
    connection?.off("getCreatedChat");
  }

  @override
  void onInit() async {
    super.onInit();
    connection = HubConnectionBuilder()
        .withUrl("https://localhost:44324/MessageHub")
        .build();
    if (connection?.state == HubConnectionState.Disconnected) {
      await connection?.start();
    }
    getData();
  }
}
