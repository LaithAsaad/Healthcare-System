import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:patient/main.dart';
import 'package:get/get.dart';
import '../data/api/login_api.dart';
import '../data/api/register_api.dart';
import '../data/models/login.dart';
import '../data/models/patient.dart';

class AuthPatientController extends GetxController {
  bool obscureText = true;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController conController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController birthDateController;

  void userLogIn(LogInModel logInModel) async {
    var response = await LoginApi().loginPatient(logInModel);

    //to get the patient id from respone after login
    String? responseBody = response['body'];
    if (response['success'] == true) {
      Map<String, dynamic> responseId = jsonDecode(responseBody!);

      sharedPreferences?.setString('email', emailController.text);
      sharedPreferences?.setInt('id', responseId['patientId']);
      // Navigate to home page on successful login
      //Get.offNamed('homePage');
      Get.offNamed('/bottomBarP');
    } else {
      // Display error message
      Get.defaultDialog(
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding: const EdgeInsets.all(20),
        titleStyle:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        title: 'Error!',
        content: Text(
          '${response['error']}',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  void addPatient(Patient patient) async {
    var response = await RegisterApi().registerPatient(patient);
    //to get the patient id from respone after registration
    String? responseBody = response['body'];
    if (response['success'] == true) {
      Map<String, dynamic> responseId = jsonDecode(responseBody!);

      sharedPreferences?.setString('email', emailController.text);
      sharedPreferences?.setInt('id', responseId['patientId']);
      Get.offNamed('/bottomBarP');
    } else {
      // Display error message
      Get.defaultDialog(
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: Text('OK'),
        ),
        titlePadding: EdgeInsets.only(top: 20),
        contentPadding: EdgeInsets.all(20),
        titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        title: 'Error!',
        content: Text(
          '${response['error']}',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  void showHidePassword() {
    obscureText = !obscureText;
    update();
  }

  void setBirthDate(String time) {
    birthDateController.text = time;
    update();
  }

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    conController = TextEditingController();
    phoneController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    birthDateController = TextEditingController();
    super.onInit();
  }
}
