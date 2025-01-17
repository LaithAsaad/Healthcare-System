import 'package:get/get.dart';
import 'package:doctor/data/models/message.dart';
import 'package:doctor/main.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../data/api/chat_api.dart';
import '../data/models/chatInfo.dart';

class ChatListController extends GetxController {
  RxList<ChatInfo> chatUsersList = <ChatInfo>[].obs;
  HubConnection? connection;

  int? doctorId = sharedPreferences?.getInt('id');

  void getData() async {
    try {
      print("Connected");
      addMessage();
      deleteMessage();
      updateMessage();
      getCreatedChat();
    } catch (e) {
      print('Connection failed: $e');
    }

    getChatMessages();

    print("Good until here");
    chatUsersList.value =
        (await ApiChatService().getDoctorChats(doctorId)) ?? [];
    await Future.delayed(const Duration(seconds: 1));
    // chatUsersList.sort((a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),);
  }

   bool checkConnect() {
    if (connection?.state == HubConnectionState.Disconnected ||connection?.state == HubConnectionState.Reconnecting) {
      return true;
    } else {
      return false;
    }
  }

  void addMessage() {
    connection?.on("addMessage", (message) {
      // print("Received message: $message");

      Message messageList =
          Message.fromJson(message?.last as Map<String, dynamic>);

      for (var element in chatUsersList) {
        if (element.chatId == messageList.chatId) {
          element.userLastMessage = messageList.messageContent;
          element.lastMessageDate = messageList.date;
          if (messageList.byPatient == true && messageList.isRead == false) {
            element.numberOfUnreadMessage = element.numberOfUnreadMessage! + 1;
          }
        }
      }
      chatUsersList.sort((a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),);
    });
  }

  void deleteMessage() {
    connection?.on("deleteMessage", (message) {
      // print("Received message: $message");

      Message messageList =
          Message.fromJson(message?.last as Map<String, dynamic>);

      for (var element in chatUsersList) {
        if (element.chatId == messageList.chatId) {
          element.userLastMessage = messageList.messageContent;
          if (messageList.byPatient == false) {
            element.numberOfUnreadMessage = 0;
          } else if (messageList.isRead == true) {
            element.numberOfUnreadMessage = 0;
          } else {
            element.numberOfUnreadMessage = element.numberOfUnreadMessage! - 1;
          }
        }
      }
      chatUsersList.refresh();
    });
  }

  void updateMessage() {
    connection?.on("updateMessage", (message) {
      // print("Received message: $message");

      Message messageList =
          Message.fromJson(message?.last as Map<String, dynamic>);
      for (var element in chatUsersList) {
        if (element.chatId == messageList.chatId) {
          element.userLastMessage = messageList.messageContent;
           element.lastMessageDate = messageList.date;
        }
      }
      chatUsersList.sort((a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),);
    });
  }

  void getChatMessages() {
    connection?.on("getChatMessages", (message) {
      // print("Received message: $message");

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
      chatUsersList.sort((a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),);
    });
  }

  void getCreatedChat() {
    connection?.on("getCreatedChat", (args) {
      var message = args?[0];
      var id = args?[1];
      var id2 =args?[2];
      var message2 = args?[3];

      if (id == doctorId) {
        ChatInfo messageList =
            ChatInfo.fromJson(message as Map<String, dynamic>);
        messageList.numberOfUnreadMessage = 1;
        chatUsersList.insert(0, messageList);
        chatUsersList.sort(
          (a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),
        );
      }
      else if( id2 == doctorId){
        ChatInfo messageList =
            ChatInfo.fromJson(message2 as Map<String, dynamic>);
        messageList.numberOfUnreadMessage = 1;
        chatUsersList.insert(0, messageList);
        chatUsersList.sort(
          (a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!),
        );
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
