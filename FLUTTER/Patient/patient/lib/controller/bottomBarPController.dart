import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient/screen/sendMessage.dart';

import '../screen/bookingManager.dart';
import '../screen/chatList.dart';
import '../screen/homePage.dart';
import '../screen/patientProfile.dart';

class BottomBarPatientController extends GetxController {
  int currentIndex = 0;
  final List<Widget> pages = [
    const MyHomePage(),
    const TestSend(),
    const ChatList(),
    const BookingManager(),
    const PatientProfilePage(),
  ];

  void changeCurrentIndex(int index) {
    currentIndex = index;
    update();
  }
}
