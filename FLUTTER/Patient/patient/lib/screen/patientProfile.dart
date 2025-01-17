
import 'package:flutter/material.dart';
import 'package:patient/screen/widget/patientInfo.dart';
import 'package:get/get.dart';




class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    // final screenWidth = mediaQuery.size.width;
    // final fontSize = screenWidth * 0.04;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black)],
                  color: Get.theme.primaryColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40))),
            ),
          ),
          profilePatientInfo(),
        ]),
      ),
    );
  }
}

