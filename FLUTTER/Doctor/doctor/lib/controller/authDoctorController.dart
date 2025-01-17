import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/api/login_api.dart';
import '../data/api/register_api.dart';
import '../data/models/dcotor.dart';
import '../data/models/login.dart';
import '../main.dart';

class AuthDoctorController extends GetxController {
  bool obscureText = true;
  bool gender = true;
  late int specId;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController conController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  void userLogIn(LogInModel logInModel) async {
    var response = await LoginApi().loginDoctor(logInModel);
    //to get the doctor id from respone after login
    String? responseBody = response['body'];
    if (response['success'] == true) {
      Map<String, dynamic> responseId = jsonDecode(responseBody!);

      sharedPreferences?.setString('email', emailController.text);
      sharedPreferences?.setInt('id', responseId['doctorId']);
      // Navigate to home page on successful login
      Get.offNamed('/bottomBarD');
    } else {
      // Display error message
      Get.defaultDialog(
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding: const EdgeInsets.all(20),
        titleStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        title: 'Error!',
        content: Text('${response['error']}'),
      );
    }
  }

  void addDoctor(Doctor doctor) async {
    var response = await RegisterApi().registerDoctor(doctor);
    //to get the doctor id from respone after registration
    String? responseBody = response['body'];
    if (response['success'] == true) {
      Map<String, dynamic> responseId = jsonDecode(responseBody!);

      sharedPreferences?.setString('email', emailController.text);
      sharedPreferences?.setInt('id', responseId['doctorId']);
      // Navigate to home page on successful registration
      // Get.offNamed('homePage');
      Get.offNamed('/bottomBarD');
    } else {
      // Display error message
      Get.defaultDialog(
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding: const EdgeInsets.all(20),
        titleStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        title: 'Error!',
        content: Text('${response['error']}'),
      );
    }
  }

  void showHidePassword() {
    obscureText = !obscureText;
    update();
  }
  void setBirthDate(String time) {
    birthDateController.text =time;
    update();
  }


  void changeGender() {
    gender = !gender;
    update();
  }
}
