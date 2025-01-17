
import 'package:flutter/cupertino.dart';
import 'package:patient/data/api/patient_api.dart';
import 'package:get/get.dart';
import '../data/models/patientProfile.dart';
import '../main.dart';

class PatientProfileController extends GetxController {
  late PatientProfile? patient;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  int? patientId = sharedPreferences?.getInt('id');

  void getDcotor() async {
    patient = (await PatientApi().getPatientById(patientId!));

    patient != null
        ? firstNameController.text = patient!.firstName
        : firstNameController.text = "";
    patient != null
        ? lastNameController.text = patient!.lastName
        : lastNameController.text = "";
    patient != null
        ? emailController.text = patient!.email
        : emailController.text = "";
    patient != null
        ? phoneController.text = patient!.phoneNumber
        : phoneController.text = "";
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    update();
  }

  void editDoctor(PatientProfile patientProfile) async {
    //address.id = sharedPreferences!.getInt('id');
    var response = await PatientApi().editPatient(patientProfile);
    if (response['success'] == true) {
      // Navigate to home page on successful registration
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: 'Patient edit successful',
        duration: Duration(seconds: 3),
      ));
    } else {
      // Display error message
      // Get.defaultDialog(
      //   confirm: TextButton(
      //     onPressed: () => Get.back(),
      //     child: Text('OK'),
      //   ),
      //   titlePadding: EdgeInsets.only(top: 20),
      //   contentPadding: EdgeInsets.all(20),
      //   titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      //   title: 'Error!',
      //   content: Text('${response['error']}'),
      //);
    }
    update();
  }

  String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }


  @override
  void onInit() {
    super.onInit();
    patient = null;
    getDcotor();
    update();
  }
}
