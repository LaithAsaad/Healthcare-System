import 'package:patient/data/api/doctor_api.dart';
import 'package:patient/data/models/specialization.dart';
import 'package:get/get.dart';
import '../data/api/spec_api.dart';
import '../data/models/doctorProfile.dart';

class ProfileDoctorController extends GetxController {
  late DoctorProfile? doctor;
  late Specialization? specialization;
  late String? image;
  late int? doctorId;

  void getDcotor() async {
    doctor = (await DcotorApi().getDoctorById(doctorId!));
    specialization =
        (await SpecializationApi().getSpecializationById(doctor!.specializationId));
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
    doctorId =Get.arguments as int;
    doctor = null;
    specialization = null;
    getDcotor();
    update();
  }
}
