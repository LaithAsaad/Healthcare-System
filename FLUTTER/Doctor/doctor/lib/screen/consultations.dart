import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/consultationsController.dart';

class Consultations extends StatelessWidget {
  const Consultations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Consultations",
              style: TextStyle(
                color: Colors.white,
              )),
          centerTitle: true,
          backgroundColor: Get.theme.primaryColor,
        ),
        body: GetBuilder<ConsultationsController>(
          init: ConsultationsController(),
          builder: (controller) => controller.messageList == null ||
                  controller.messageList!.isEmpty
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
                  itemCount: controller.messageList?.length,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Slidable(
                        key: ValueKey(controller.messageList?[index].patientId),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {
                            controller.replyToConsultations(
                                index,
                                controller.messageList![index].patientId,
                                controller.messageList![index].userFirstName,
                                controller.messageList![index].userLastName,
                                controller.messageList![index].userLastMessage);
                          }),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                controller.replyToConsultations(
                                    index,
                                    controller.messageList![index].patientId,
                                    controller
                                        .messageList![index].userFirstName,
                                    controller.messageList![index].userLastName,
                                    controller
                                        .messageList![index].userLastMessage);
                              },
                              backgroundColor: Colors.green,
                              icon: Icons.send,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                controller.messageList?.removeAt(index);
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
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
                            minVerticalPadding: 10,
                            title: Text(
                              "Send by ${controller.messageList?[index].userFirstName} ${controller.messageList?[index].userLastName}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                controller.messageList![index].userFirstName[0]
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Get.theme.primaryColor),
                              ),
                            ),
                            onTap: () {
                              Get.defaultDialog(
                                title: 'Consultation Content',
                                content: Text(
                                    controller
                                        .messageList![index].userLastMessage,
                                    textAlign: TextAlign.center),
                                cancel: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red)),
                                  onPressed: () {
                                    controller.ignoreMessage(index);
                                    Get.back();
                                  },
                                  child: const Text('Ignore'),
                                ),
                                confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Get.theme.primaryColor)),
                                  onPressed: () {
                                    Get.back();
                                    controller.replyToConsultations(
                                        index,
                                        controller
                                            .messageList![index].patientId,
                                        controller
                                            .messageList![index].userFirstName,
                                        controller
                                            .messageList![index].userLastName,
                                        controller.messageList![index]
                                            .userLastMessage);
                                  },
                                  child: const Text('Answer'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}
