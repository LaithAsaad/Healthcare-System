import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/controller/chatMessageController.dart';
import 'package:photo_view/photo_view.dart';
import '../data/api/patient_api.dart';
import '../data/models/chat.dart';

class ChatDetailPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

  ChatDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    ChatMessageController controller = Get.put(ChatMessageController());
    FocusNode myFocusNode = FocusNode();

    return Scaffold(
      key: _mainScaffoldKey,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Get.theme.primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: Get.arguments.userImage != null
                      ? AssetImage("images/${Get.arguments.userImage}")
                      : const AssetImage("images/unknown.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Dr. ${Get.arguments.userFirstName} ${Get.arguments.userLastName}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_rounded),
                  color: Get.theme.primaryColor,
                  onPressed: () {
                    Get.toNamed('/doctorProfile',
                        arguments: Get.arguments.chatUserId);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(
        () => Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            // ignore: unnecessary_null_comparison
            controller.message2 == null || controller.message2.isEmpty
                ? SafeArea(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Expanded(
                          flex: 3,
                          child: Lottie.asset('images/data2.json'),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'No Message Available',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ]))
                : ListView.builder(
                    reverse: true,
                    key: UniqueKey(),
                    itemCount: controller.message2.length,
                    // controller: scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 60),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final textPainter = TextPainter(
                          text: TextSpan(
                              text: controller.message2[index].messageContent),
                          textDirection: TextDirection.ltr,
                        );
                        textPainter.layout();

                        final textWidth = textPainter.size.width;

                        double itemWidth = constraints.maxWidth /
                            controller.message2[index].messageContent.length;
                        return SizedBox(
                            width: itemWidth,
                            child: ListTile(
                              visualDensity: const VisualDensity(vertical: -1),
                              onLongPress: () {
                                if (controller.message2[index].byPatient ==
                                    true) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Modify Message"),
                                        content: const Text("Edit or Delete?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Cancel",
                                                style: TextStyle(
                                                    color: Colors.blueGrey)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          controller
                                                  .checkMessageLength(index)?
                                          TextButton(
                                            child: const Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: Colors.greenAccent),
                                            ),
                                            onPressed: () {
                                              controller.editMessage(
                                                  controller.message2[index]
                                                      .messageContent,
                                                  index);
                                              //yazan
                                              Navigator.of(context).pop();
                                              SchedulerBinding.instance
                                                  .addPostFrameCallback((_) {
                                                myFocusNode.requestFocus();
                                              });
                                            },
                                          ):const Text(''),
                                          TextButton(
                                            child: const Text("Delete",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      deleteContext) {
                                                    return AlertDialog(
                                                        title: const Text(
                                                            "Delete Message?"),
                                                        content: const Text(
                                                            "Delete for Everyone"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                "Back",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueGrey)),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      deleteContext)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                              "Ok",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .greenAccent),
                                                            ),
                                                            onPressed: () {
                                                              controller.deleteMessage(
                                                                  controller
                                                                          .message2[
                                                                      index],
                                                                  controller
                                                                      .message2);
                                                              Navigator.of(
                                                                      deleteContext)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ]);
                                                  });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              title: Align(
                                alignment:
                                    controller.message2[index].byPatient ==
                                            false
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                child: controller.checkMessageLength(index) ==
                                        true
                                    ? ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            minWidth: 105),
                                        child: Container(
                                          width: textWidth * 2,
                                          decoration: BoxDecoration(
                                              color:
                                                  controller.message2[index].byPatient == false
                                                      ? const Color.fromRGBO(
                                                          24, 168, 141, 1)
                                                      : Get.theme.primaryColor,
                                              borderRadius: controller
                                                          .message2[index]
                                                          .byPatient ==
                                                      false
                                                  ? const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(50.0),
                                                      topRight:
                                                          Radius.circular(50.0),
                                                      bottomLeft:
                                                          Radius.circular(5.0),
                                                      bottomRight:
                                                          Radius.circular(50.0))
                                                  : const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(50.0),
                                                      topRight:
                                                          Radius.circular(50.0),
                                                      bottomLeft:
                                                          Radius.circular(50.0),
                                                      bottomRight:
                                                          Radius.circular(5.0)),
                                              border: Border.all(
                                                color: controller
                                                            .message2[index]
                                                            .byPatient ==
                                                        false
                                                    ? const Color.fromRGBO(
                                                        24, 168, 141, 1)
                                                    : Get.theme.primaryColor,
                                                width: 2.0,
                                              )),
                                          child: ListTile(
                                              title: Text(
                                                  controller.message2[index]
                                                      .messageContent,
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                              subtitle: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${controller.message2[index].isEdited == true ? "edited at " : ""}${controller.message2[index].date.hour > 12 ? controller.message2[index].date.hour - 12 : controller.message2[index].date.hour}:${controller.message2[index].date.minute.toString().padLeft(2, '0')} ${controller.message2[index].date.hour > 12 ? "PM" : "AM"}",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    212,
                                                                    212,
                                                                    212)),
                                                      ),
                                                    ),
                                                    if (controller
                                                            .message2[index]
                                                            .byPatient ==
                                                        true)
                                                      controller.message2[index]
                                                                  .isRead ==
                                                              false
                                                          ? const Icon(
                                                              Icons.done,
                                                              color: Colors
                                                                  .greenAccent,
                                                            )
                                                          : const Icon(
                                                              Icons.done_all,
                                                              color: Colors
                                                                  .greenAccent,
                                                            ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      )
                                    : GestureDetector(
                                        child: Column(
                                          crossAxisAlignment: controller
                                                      .message2[index]
                                                      .byPatient ==
                                                  false
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                  border: Border.all(
                                                      color: controller
                                                                  .message2[
                                                                      index]
                                                                  .byPatient ==
                                                              false
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 24, 156, 168)
                                                          : Get.theme
                                                              .primaryColor)),
                                              width: Get.mediaQuery.size.width/2,
                                              height: Get.mediaQuery.size.width/2,
                                              child: Image(
                                                  fit: BoxFit.contain,
                                                  key: Key(controller
                                                      .message2[index]
                                                      .messageContent
                                                      .substring(3)),
                                                  image: FileImage(File(
                                                      'F:/fourth year Project/chatImages/${controller.message2[index].messageContent.substring(3)}'))),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${controller.message2[index].isEdited == true ? "edited at " : ""}${controller.message2[index].date.hour > 12 ? controller.message2[index].date.hour - 12 : controller.message2[index].date.hour}:${controller.message2[index].date.minute.toString().padLeft(2, '0')} ${controller.message2[index].date.hour > 12 ? "PM" : "AM"}   ",
                                                    textAlign: controller
                                                                .message2[index]
                                                                .byPatient ==
                                                            false
                                                        ? TextAlign.center
                                                        : TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Get.theme
                                                            .primaryColor),
                                                  ),
                                                ),
                                                if (controller.message2[index]
                                                        .byPatient ==
                                                    true)
                                                  controller.message2[index]
                                                              .isRead ==
                                                          false
                                                      ? const Icon(
                                                          Icons.done,
                                                          color: Colors
                                                              .greenAccent,
                                                        )
                                                      : const Icon(
                                                          Icons.done_all,
                                                          color: Colors
                                                              .greenAccent,
                                                        ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    PhotoView(
                                                      disableGestures: true,
                                                      imageProvider: FileImage(File(
                                                          'F:/fourth year Project/chatImages/${controller.message2[index].messageContent.substring(3)}')),
                                                      backgroundDecoration:
                                                          BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        color: Colors.white
                                                            .withOpacity(0.4),
                                                      ),
                                                      tightMode: true,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                      child: const Icon(
                                                        Icons.cancel_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ));
                      });
                    },
                  ),
            const SizedBox(
              height: 5,
              //child: ,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.image_rounded,
                            size: 25.0,
                            color: Get.theme.primaryColor,
                          ),
                          onPressed: controller.pickAndMoveImage),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.textEditingController,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 5) +
                              const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          hintText: 'Enter Your message',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        if (controller.textEditingController.text.isNotEmpty) {
                          if (Get.arguments.chatId == null) {
                            Chat? chat = await controller
                                .createChat(Get.arguments.chatUserId,controller.textEditingController.text);
                            Get.arguments.chatId = chat?.id;

                            // String textFieldContent =
                            //     controller.textEditingController.text;
                            // PatientApi()
                            //     .sendMessage(chat?.id, textFieldContent);
                            controller.clearText();
                            controller.getFirstMessage();
                          } else {
                            String textFieldContent =
                                controller.textEditingController.text;
                            if (controller.editing) {
                              PatientApi().updateMessage(
                                  controller
                                      .message2[controller.messageIndex].id,
                                  textFieldContent);
                              controller.editing = false;
                            } else {
                              PatientApi().sendMessage(
                                  Get.arguments.chatId, textFieldContent);
                            }
                            controller.clearText();
                          }
                        }
                      },
                      backgroundColor: Get.theme.primaryColor,
                      elevation: 0,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
