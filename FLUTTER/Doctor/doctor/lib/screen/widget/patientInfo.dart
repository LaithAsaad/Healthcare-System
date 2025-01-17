import 'package:flutter/material.dart';
import 'package:doctor/controller/patientProfileController.dart';
import 'package:get/get.dart';

final _formKey = GlobalKey<FormState>();

Widget profilePatientInfo() {
  final mediaQuery = Get.mediaQuery;
  final screenWidth = mediaQuery.size.width;
  final fontSize = screenWidth * 0.04;

  return GetBuilder<PatientProfileController>(
    init: PatientProfileController(),
    builder: (controller) => controller.patient == null
        ? CircularProgressIndicator(
            color: Get.theme.primaryColor,
          )
        : Column(
            children: [
             ListTile(
                title: Text(
                  'User Name',
                  style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${controller.patient!.firstName} ${controller.patient!.lastName}',
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                leading: Icon(Icons.person,size: fontSize*1.6,),
                iconColor: Get.theme.primaryColor,
              ),
              ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  controller.patient!.email,
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                leading: Icon(
                  Icons.email_outlined,
                  size: fontSize * 1.6,
                ),
                iconColor: Get.theme.primaryColor,
              ),
              ListTile(
                title: Text('Phone Number',
                    style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                  controller.patient!.phoneNumber,
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                leading: Icon(
                  Icons.phone,
                  size: fontSize * 1.6,
                ),
                iconColor: Get.theme.primaryColor,
              ),
              ListTile(
                title: Text('Age',
                    style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                  controller.calculateAge(controller.patient!.birthDate),
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                leading: Icon(
                  Icons.date_range,
                  size: fontSize * 1.6,
                ),
                iconColor: Get.theme.primaryColor,
              ),
            ],
          ),
  );
}
