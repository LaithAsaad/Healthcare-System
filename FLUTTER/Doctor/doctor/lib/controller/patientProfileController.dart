import 'package:doctor/data/api/patient_api.dart';
import 'package:get/get.dart';
import '../data/models/patientProfile.dart';

class PatientProfileController extends GetxController {
  late PatientProfile? patient;

  late int? patientId;

  void getDcotor() async {
    patient = (await PatientApi().getPatientById(patientId!));
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
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
    patientId = Get.arguments as int;
    patient = null;
    getDcotor();
    update();
  }
}
