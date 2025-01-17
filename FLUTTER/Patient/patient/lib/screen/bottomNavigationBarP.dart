import 'package:flutter/material.dart';
import 'package:patient/controller/bottomBarPController.dart';
import 'package:get/get.dart';

class BottomNavigationBarPatient extends StatelessWidget {
  const BottomNavigationBarPatient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:GetBuilder<BottomBarPatientController>(
        init: BottomBarPatientController(),
        builder:(controller) =>controller.pages[controller.currentIndex]),
      bottomNavigationBar: GetBuilder<BottomBarPatientController>(
        init: BottomBarPatientController(),
        builder:(controller) => BottomNavigationBar(
          selectedItemColor: Get.theme.primaryColor,
          selectedLabelStyle: TextStyle(color: Get.theme.primaryColor),
          unselectedItemColor: Colors.blueGrey,
          unselectedLabelStyle: TextStyle(color:Colors.blueGrey ),
          currentIndex:controller.currentIndex,
          onTap: (int index) {
            controller.changeCurrentIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.healing_outlined),
              label: 'Consultation',
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