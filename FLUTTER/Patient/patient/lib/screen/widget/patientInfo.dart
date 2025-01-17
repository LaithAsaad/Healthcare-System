import 'package:flutter/material.dart';
import 'package:patient/controller/patientProfileController.dart';
import 'package:patient/data/models/patientProfile.dart';
import 'package:patient/main.dart';
import 'package:get/get.dart';

final _formKey = GlobalKey<FormState>();

dynamic editPatientInfo() {
  Get.defaultDialog(
      cancel: GetBuilder<PatientProfileController>(
        builder: (controller) => ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red)),
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
        ),
      ),
      confirm: GetBuilder<PatientProfileController>(
        builder: (controller) => ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Get.theme.primaryColor)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              var doctor = PatientProfile(
                id: controller.patient!.id,
                applicationUserId: controller.patient!.applicationUserId,
                firstName: controller.firstNameController.text,
                lastName: controller.lastNameController.text,
                email: controller.emailController.text,
                phoneNumber: controller.phoneController.text,
                birthDate: controller.patient!.birthDate
              );

              controller.editDoctor(doctor);
            }
          },
          child: Text('Save changes'),
        ),
      ),
      title: 'Edit Profile',
      content: GetBuilder<PatientProfileController>(
        init: PatientProfileController(),
        builder: (controller) => Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  maxLength: 20,
                  controller: controller.firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
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
                        Icons.person,
                        color: Get.theme.primaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor, width: 2)),
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      hintText: 'Enter your first name'),
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  maxLength: 20,
                  controller: controller.lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
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
                        Icons.person,
                        color: Get.theme.primaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor, width: 2)),
                      labelText: 'Last Name',
                      labelStyle: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      hintText: 'Enter your last name'),
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: controller.phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!isValidPhoneNumber(
                        controller.phoneController.text)) {
                      return 'Please enter a vaild syrain phone number (09........)';
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
                        Icons.phone,
                        color: Get.theme.primaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor, width: 2)),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      hintText: 'Enter your phone number'),
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!isValidEmail(controller.emailController.text)) {
                      return 'Your Email is not vaild';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Get.theme.primaryColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Get.theme.primaryColor)),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Get.theme.primaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor, width: 2)),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      hintText: 'Enter valid mail id as abc@gmail.com'),
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ));
}

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
                  '${controller.patient!.email}',
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                leading: Icon(Icons.email_outlined,size: fontSize*1.6,),
                iconColor: Get.theme.primaryColor,
              ),
              ListTile(
                title: Text('Phone Number',
                    style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${controller.patient!.phoneNumber}',
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                leading: Icon(Icons.phone,size: fontSize*1.6,),
                iconColor: Get.theme.primaryColor,
              ),
              ListTile(
                title: Text('Age',
                    style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${controller.calculateAge(controller.patient!.birthDate)}',
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                leading: Icon(Icons.date_range,size: fontSize*1.6,),
                iconColor: Get.theme.primaryColor,
              ),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () {
                      editPatientInfo();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      backgroundColor: Get.theme.primaryColor,
                    ),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: fontSize,
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () {
                      sharedPreferences?.clear();
                      Get.offAllNamed('/loginP');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      backgroundColor: Get.theme.primaryColor,
                    ),
                    child: Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: fontSize,
                      ),
                    ),
                  )),
            ],
          ),
  );
}

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

bool isValidPhoneNumber(String phoneNumber) {
  return RegExp(r'^0[0-9]{9}$').hasMatch(phoneNumber);
}
