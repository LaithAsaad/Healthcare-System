import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:doctor/controller/chatListController.dart';
import 'package:doctor/screen/chatDetailPage.dart';
import '../data/models/chatInfo.dart';

List<Color> colors = [
  Get.theme.primaryColor,
  const Color.fromARGB(255, 24, 156, 168),
];

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    ChatListController controller = Get.put(ChatListController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Conversations",
              style: TextStyle(
                color: Colors.white,
              )),
          centerTitle: true,
          //update color
          backgroundColor: Get.theme.primaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: Search());
                },
                icon: const Icon(Icons.search, color: Colors.white)),
          ],
        ),
        body: Obx(
          () => chatPage(controller.chatUsersList, controller),
        ));
  }
}

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ChatListController controller = Get.find<ChatListController>();
    return Obx(() {
      List<ChatInfo> availableChats = controller.chatUsersList
          .where((element) =>
              element.userFirstName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.userLastName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return chatPage(availableChats, controller);
      
    });
  }
}

Widget chatPage(List<ChatInfo>? list, ChatListController controller) {
  return list == null || list.isEmpty
      ? SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            flex: 3,
            child: Lottie.asset('images/data2.json'),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'No Chat Available',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ]))
      : ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: colors[index % 2],
                  child: Text(
                    list[index].userFirstName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                title: Text(
                  "${list[index].userFirstName} ${list[index].userLastName}",
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                   controller.checkImageMessage(list[index].userLastMessage!),
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: list[index].numberOfUnreadMessage! > 0
                    ? CircleAvatar(
                        maxRadius: 11,
                        backgroundColor: Get.theme.primaryColor,
                        child: Text("${list[index].numberOfUnreadMessage}",
                            style: const TextStyle(color: Colors.white)),
                      )
                    : const Text(""),
                isThreeLine: true,
                onTap: () async {
                  list[index].numberOfUnreadMessage = 0;

                  await controller.connection?.invoke("TriggerChatApi",
                      args: [false, list[index].chatId.toString()]);
                  controller.offMethodConnection();

                  Get.to(() => ChatDetailPage(), arguments: list[index])
                      ?.then((value) => controller.getData());
                },
              ),
            );
          },
        );
}


// Widget chatPage(List<ChatInfo>? list, ChatListController controller) {
//   return list == null || list.isEmpty
//       ? SafeArea(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Expanded(
//             flex: 3,
//             child: Lottie.asset('images/data2.json'),
//           ),
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               child: const Text(
//                 'No Chat Available',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           )
//         ]))
//       : Obx(
//           () => ListView.builder(
//             itemCount: list.length,
//             shrinkWrap: true,
//             padding: const EdgeInsets.only(top: 16),
//             physics: const AlwaysScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: colors[index % 2],
//                     child: Text(
//                       list[index].userFirstName[0].toUpperCase(),
//                       style: const TextStyle(fontSize: 24),
//                     ),
//                   ),
//                   title: Text(
//                     "${list[index].userFirstName} ${list[index].userLastName}",
//                     style: const TextStyle(color: Colors.black),
//                   ),
//                   subtitle: Text(
//                     list[index].userLastMessage!,
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   trailing: list[index].numberOfUnreadMessage! > 0
//                       ? CircleAvatar(
//                           maxRadius: 11,
//                           backgroundColor: Get.theme.primaryColor,
//                           child: Text("${list[index].numberOfUnreadMessage}",
//                               style: const TextStyle(color: Colors.white)),
//                         )
//                       : const Text(""),
//                   isThreeLine: true,
//                   onTap: () async {
//                     list[index].numberOfUnreadMessage = 0;

//                     await controller.connection?.invoke("TriggerChatApi",
//                         args: [false, list[index].chatId.toString()]);
//                     controller.offMethodConnection();

//                     Get.to(() => ChatDetailPage(), arguments: list[index])
//                         ?.then((value) => controller.getData());
//                   },
//                 ),
//               );
//             },
//           ),
//         );
// }
