
import 'package:flutter/material.dart';
import 'package:doctor/controller/profileDoctorController.dart';
import 'package:doctor/screen/widget/doctorInfo.dart';
import 'package:get/get.dart';

import '../main.dart';



class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                    boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black)],
                    color: Get.theme.primaryColor,
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(40))),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(200.0),
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: GetBuilder<ProfileDoctorController>(
                                init: ProfileDoctorController(),
                                builder: (controller) => controller.doctor?.image == null
                                    ? Image.asset(
                                        'images/unknown.jpg',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'images/${controller.doctor!.image}',
                                        fit: BoxFit.cover,
                                      ),
                              ))),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: ListTile(
              iconColor: Get.theme.primaryColor,
              title: Text('Profile Information',style: TextStyle(fontSize: fontSize),),
              leading: const Icon(Icons.info),
              trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editDoctorInfo();
                  },
                  hoverColor: null),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Get.theme.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: () {
                profileInfo();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: ListTile(
              iconColor: Get.theme.primaryColor,
              title: Text('Address',style: TextStyle(fontSize: fontSize),),
              leading: const Icon(Icons.location_on),
              trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editAddress();
                  },
                  hoverColor: null),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Get.theme.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: () {
                addressInfo();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: ListTile(
              iconColor: Get.theme.primaryColor,
              title: Text('Available Time',style: TextStyle(fontSize: fontSize),),
              leading: const Icon(Icons.access_time_rounded),
              trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.toNamed('availableTime');
                  },
                  hoverColor: null),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Get.theme.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: () {
                availableTimeInfo();
              },
            ),
          ),
          Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () {
                      sharedPreferences?.clear();
                      Get.offAllNamed('/loginD');
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
        ]),
      ),
    );
  }
}

