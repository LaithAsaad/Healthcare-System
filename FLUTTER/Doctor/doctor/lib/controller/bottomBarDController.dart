import 'package:flutter/material.dart';
import 'package:doctor/screen/bookingManager.dart';
import 'package:doctor/screen/doctorProfile.dart';
import 'package:get/get.dart';
import '../screen/chatList.dart';
import '../screen/consultations.dart';

class BottomBarDoctorController extends GetxController {
  int currentIndex = 0;
  final List<Widget> pages = [
    const Consultations(),
    const ChatList(),
    const BookingManager(),
    const DoctorProfilePage(),
  ];

  void changeCurrentIndex(int index) {
    currentIndex = index;
    update();
  }
}
