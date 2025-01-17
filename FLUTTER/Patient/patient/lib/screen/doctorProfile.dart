
import 'package:flutter/material.dart';
import 'package:patient/controller/profileDoctorController.dart';
import 'package:patient/screen/widget/doctorInfo.dart';
import 'package:get/get.dart';



class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.back(),
        child: Icon(Icons.arrow_back),
        backgroundColor: Get.theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black)],
                    color: Get.theme.primaryColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(40))),
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
              leading: Icon(Icons.info),
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
              leading: Icon(Icons.location_on),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Get.theme.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: () {
                addressInfo(Get.arguments);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: ListTile(
              iconColor: Get.theme.primaryColor,
              title: Text('Available Time',style: TextStyle(fontSize: fontSize),),
              leading: Icon(Icons.access_time_rounded),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Get.theme.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: () {
                availableTimeInfo(Get.arguments);
              },
            ),
          )
        ]),
      ),
    );
  }
}

