import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/addressController.dart';
import '../../controller/avaliableTimeController.dart';
import '../../controller/profileDoctorController.dart';

// final _formKey = GlobalKey<FormState>();

dynamic availableTimeInfo(int id) {
  Get.defaultDialog(
      cancel: ElevatedButton(
        style:
            ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
        onPressed: () => Get.back(),
        child: Text('Cancel'),
      ),
      title: 'Available Time',
      content: GetBuilder<AvailableTimeController>(
          init: AvailableTimeController(id),
          builder: (controller) => controller.availableTimeList == null ||
                  controller.availableTimeList!.isEmpty
              ? Text('The doctor does not have available times')
              : Container(
                  width: Get.width / 2,
                  height: Get.height / 3,
                  child: ListView.builder(
                      itemCount: controller.availableTimeList?.length,
                      itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Get.theme.primaryColor),
                            ),
                            child: Column(children: [
                              Text(
                                  '${controller.getDay(controller.availableTimeList![index].dayId)}',
                                  style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "From: ${controller.availableTimeList![index].startTime.hour.toString().padLeft(2, '0')}:${controller.availableTimeList![index].startTime.minute.toString().padLeft(2, '0')} To: ${controller.availableTimeList![index].endTime.hour.toString().padLeft(2, '0')}:${controller.availableTimeList![index].endTime.minute.toString().padLeft(2, '0')}"),
                              controller.availableTimeList?[index]
                                          .isAvailable ==
                                      true
                                  ? Text('Available')
                                  : Text('Not Available')
                            ]),
                          )),
                )));
}

dynamic addressInfo(int id) {
  Get.defaultDialog(
      cancel: ElevatedButton(
        style:
            ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
        onPressed: () => Get.back(),
        child: Text('Cancel'),
      ),
      title: 'Address Information',
      content: GetBuilder<AddresController>(
        init: AddresController(id),
        builder: (controller) => controller.address == null
            ? CircularProgressIndicator(
                color: Get.theme.primaryColor,
              )
            : Column(
                children: [
                  ListTile(
                    title: Text(
                      'City',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${controller.address!.city}'),
                    leading: Icon(Icons.location_city),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text(
                      'Governorate',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${controller.address!.governorate}'),
                    leading: Icon(Icons.holiday_village),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text('Street',
                        style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text('${controller.address!.street}'),
                    leading: Icon(Icons.edit_road),
                    iconColor: Get.theme.primaryColor,
                  ),
                ],
              ),
      ));
}

dynamic profileInfo() {
  Get.defaultDialog(
      cancel: ElevatedButton(
        style:
            ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
        onPressed: () => Get.back(),
        child: Text('Cancel'),
      ),
      title: 'Profile Information',
      content: GetBuilder<ProfileDoctorController>(
        init: ProfileDoctorController(),
        builder: (controller) => controller.doctor == null
            ? CircularProgressIndicator(
                color: Get.theme.primaryColor,
              )
            : Column(
                children: [
                  ListTile(
                    title: Text(
                      'Full Name',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Dr. ${controller.doctor!.firstName} ${controller.doctor!.lastName}'),
                    leading: Icon(Icons.person),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${controller.doctor!.email}'),
                    leading: Icon(Icons.email_outlined),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text('Phone Number',
                        style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text('${controller.doctor!.phoneNumber}'),
                    leading: Icon(Icons.phone),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text('Specialization',
                        style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text('${controller.specialization!.name}'),
                    leading: Icon(Icons.medical_services_outlined),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text(
                      'Gender',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: controller.doctor!.gender == true
                        ? Text('Male')
                        : Text('Female'),
                    leading: controller.doctor!.gender == true
                        ? Icon(Icons.male)
                        : Icon(Icons.female),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text(
                      'Age',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${controller.calculateAge(controller.doctor!.birthDate)}'),
                    leading: Icon(Icons.date_range),
                    iconColor: Get.theme.primaryColor,
                  ),
                ],
              ),
      ));
}