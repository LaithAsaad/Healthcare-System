
import 'package:flutter/material.dart';
import 'package:doctor/screen/widget/patientInfo.dart';
import 'package:get/get.dart';




class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.back(),
        backgroundColor: Get.theme.primaryColor,
        child: const Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black)],
                  color: Get.theme.primaryColor,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(40))),
            ),
          ),
          profilePatientInfo(),
        ]),
      ),
    );
  }
}

