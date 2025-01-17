import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/bottomBarDController.dart';

class BottomNavigationBarDoctor extends StatelessWidget {
  const BottomNavigationBarDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BottomBarDoctorController>(
          init: BottomBarDoctorController(),
          builder: (controller) => controller.pages[controller.currentIndex]),
      bottomNavigationBar: GetBuilder<BottomBarDoctorController>(
        init: BottomBarDoctorController(),
        builder: (controller) => BottomNavigationBar(
          selectedItemColor: Get.theme.primaryColor,
          selectedLabelStyle: TextStyle(color: Get.theme.primaryColor),
          unselectedItemColor: Colors.blueGrey,
          unselectedLabelStyle: const TextStyle(color:Colors.blueGrey ),
          currentIndex: controller.currentIndex,
          onTap: (int index) {
            controller.changeCurrentIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer_rounded),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
