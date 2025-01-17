import 'package:flutter/material.dart';
import 'package:doctor/controller/avaliableTimeController.dart';
import 'package:doctor/data/models/availableTime.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AvailableTimePage extends StatelessWidget {
  const AvailableTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: GetBuilder<AvailableTimeController>(
          init: AvailableTimeController(),
          builder: (controller) => Scaffold(
              appBar: AppBar(
                  backgroundColor: Get.theme.primaryColor,
                  title: const Text('Avaliable Time'),
                  centerTitle: true,
                  bottom: TabBar(
                    onTap: (value) {
                      controller.changeIndex(value);
                      controller.search(value + 1);
                    },
                    isScrollable: true,
                    tabs: const [
                      Tab(child: Text('Saturday')),
                      Tab(child: Text('Sunday')),
                      Tab(child: Text('Monday')),
                      Tab(child: Text('Tuesday')),
                      Tab(child: Text('Wednesday')),
                      Tab(child: Text('Thursday')),
                      Tab(child: Text('Friday')),
                    ],
                  )),
              body: TabBarView(
                children: [
                  setAvailableTime(controller),
                  setAvailableTime(controller),
                  setAvailableTime(controller),
                  setAvailableTime(controller),
                  setAvailableTime(controller),
                  setAvailableTime(controller),
                  setAvailableTime(controller),
                ],
              )),
        ));
  }
}

Widget setAvailableTime(AvailableTimeController controller) {
  final formKey = GlobalKey<FormState>();
  return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextButton(
              onLongPress: () {
                Get.defaultDialog(
                  title: 'Delete Start Time',
                  content: const Text('Do you wnat to delete this time?'),
                  cancel: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Get.theme.primaryColor)),
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  confirm: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      controller.startTimeController.text = '';
                      Get.back();
                    },
                    child: const Text('Delete'),
                  ),
                );
              },
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: Get.context!,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Get.theme.primaryColor, // <-- SEE HERE
                          ),
                        ),
                        child: child!,
                      );
                    });
                if (pickedTime != null) {
                  controller.setStartTime(pickedTime);
                }
              },
              child: TextFormField(
                enabled: false,
                maxLength: 5,
                controller: controller.startTimeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your start time';
                  } else if (!isValidTime(value)) {
                    return 'Please enter valid time [min => 00:00 and max =>23:59]';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5)),
                  counterText: '',
                  prefixIcon: Icon(
                    Icons.access_time_outlined,
                    color: Get.theme.primaryColor,
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Get.theme.primaryColor, width: 1.5)),
                  labelText: 'Start Time',
                  labelStyle: TextStyle(
                    color: Get.theme.primaryColor,
                  ),
                ),
                style: TextStyle(color: Get.theme.primaryColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextButton(
              onLongPress: () {
                Get.defaultDialog(
                  title: 'Delete End Time',
                  content: const Text('Do you wnat to delete this time?'),
                  cancel: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Get.theme.primaryColor)),
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  confirm: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      controller.endTimeController.text = '';
                      Get.back();
                    },
                    child: const Text('Delete'),
                  ),
                );
              },
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: Get.context!,
                  builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Get.theme.primaryColor, // <-- SEE HERE
                          ),
                        ),
                        child: child!,
                      );
                    }
                );
                if (pickedTime != null) {
                  controller.setEndTime(pickedTime);
                }
              },
              child: TextFormField(
                enabled: false,
                maxLength: 5,
                controller: controller.endTimeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your end time';
                  } else if (controller.validEndTime()) {
                    return 'End time must be between [start time + 2 & start time + 4]';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5)),
                  counterText: '',
                  prefixIcon: Icon(
                    Icons.access_time_outlined,
                    color: Get.theme.primaryColor,
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Get.theme.primaryColor, width: 1.5)),
                  labelText: 'End Time',
                  labelStyle: TextStyle(
                    color: Get.theme.primaryColor,
                  ),
                ),
                style: TextStyle(color: Get.theme.primaryColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: CheckboxListTile(
                title: const Text('Is Avaliable'),
                activeColor: Get.theme.primaryColor,
                value: controller.isAvailable,
                onChanged: (value) {
                  controller.changeAvailable();
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: controller.isAvailable == true
                ? null
                : TextFormField(
                    maxLines: 2,
                    controller: controller.reasonController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your reason';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        counterText: '',
                        hintStyle: TextStyle(color: Get.theme.primaryColor),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Get.theme.primaryColor)),
                        prefixIcon: Icon(
                          Icons.text_snippet_outlined,
                          color: Get.theme.primaryColor,
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.primaryColor, width: 2)),
                        labelText: 'Reason Of Unavilability',
                        labelStyle: TextStyle(
                          color: Get.theme.primaryColor,
                        ),
                        hintText: 'Enter your reason'),
                    style: TextStyle(color: Get.theme.primaryColor),
                  ),
          ),
          Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

                    var availableTime = AvailableTime(
                        id: controller.currentTime?.id ?? 0,
                        doctorId: controller.doctorId!,
                        dayId: controller.currentIndex,
                        startTime: DateTime.parse(
                            "$formattedDate ${controller.startTimeController.text}:00"),
                        endTime: DateTime.parse(
                            "$formattedDate ${controller.endTimeController.text}:00"),
                        isAvailable: controller.isAvailable,
                        reasonOfUnavilability: controller.isAvailable == false
                            ? controller.reasonController.text
                            : null);
                    controller.editAvailableTime(availableTime);
                    controller.addAvailableTime(availableTime);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  backgroundColor: Get.theme.primaryColor,
                ),
                child: const Text(" Save "),
              )),
          Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  if (controller.currentTime?.id != null) {
                    Get.defaultDialog(
                      title: 'Delete Available Time',
                      content: const Text(
                          'Do you wnat to delete this available time?'),
                      cancel: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Get.theme.primaryColor)),
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      confirm: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                        onPressed: () {
                          controller
                              .deleteAvailableTime(controller.currentTime!.id!);
                          controller.editAvailableTimeAfterDelete(
                              controller.currentTime!.id!);
                          Get.back();
                        },
                        child: const Text('Delete'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  backgroundColor: Colors.red,
                ),
                child: const Text("Delete"),
              )),
        ],
      ));
}

bool isValidTime(String time) {
  return RegExp(r'^([0-1][0-9]|2[0-3])[:][0-5][0-9]$').hasMatch(time);
}
