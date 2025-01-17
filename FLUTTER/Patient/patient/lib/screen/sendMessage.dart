// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/data/models/message.dart';
import '../controller/sendMessageController.dart';

class TestSend extends StatelessWidget {
  const TestSend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Consultation'),
        centerTitle: true,
        backgroundColor: Get.theme.primaryColor,
      ),
      body: GetBuilder<SendMessageController>(
        init: SendMessageController(),
        builder: (controller) => Stack(fit: StackFit.expand, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 68.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                // ignore: unnecessary_null_comparison
                child: controller.messages == null ||
                        controller.messages.isEmpty
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
                                  'No Consultation Available',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ]))
                    : ListView.builder(
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(50.0)),
                          ),
                                child: ListTile(
                                    onTap: () {
                                      Get.defaultDialog(
                                        title: 'Message Content',
                                        content: Text(
                                            controller
                                                .messages[index].messageContent,
                                            textAlign: TextAlign.center),
                                        cancel: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.red)),
                                          onPressed: () => Get.back(),
                                          child: Text('Cancel'),
                                        ),
                                      );
                                    },
                                    leading: const Icon(
                                      Icons.chevron_right_outlined,
                                      color: Colors.white,
                                    ),
                                    // tileColor: Get.theme.primaryColor,
                                    title: Text(
                                      controller.messages[index].messageContent
                                              .length
                                              .isLowerThan(20)
                                          ? controller
                                              .messages[index].messageContent
                                          : "${controller.messages[index].messageContent.substring(0, 20)} . . .",
                                      style: const TextStyle(color: Colors.white),
                                    ),),
                              ),
                            ),
                        itemCount: controller.messages.length),
              ),
            ]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: TextField(
                          controller: controller.messageController,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 5) + EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            hintText: 'Enter Your consultation',
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Get.theme.primaryColor,
                          ),
                          iconSize: 22,
                          onPressed: () {
                            if (controller.messageController.text.isNotEmpty) {
                              Message newConsultation = Message(
                                  id: 0,
                                  chatId: 0,
                                  messageContent:
                                      controller.messageController.text,
                                  date: DateTime.now(),
                                  byPatient: true,
                                  isEdited: false,
                                  isRead: false);
                              controller.sendConsultation(newConsultation);
                              controller.messageController.text = '';
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
