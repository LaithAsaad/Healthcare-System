import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:doctor/data/api/doctor_api.dart';
import 'package:doctor/data/models/specialization.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/api/spec_api.dart';
import '../data/models/doctorProfile.dart';
import '../main.dart';
import 'package:path/path.dart' as path;

class ProfileDoctorController extends GetxController {
  late DoctorProfile? doctor;
  late Specialization? specialization;
  late String? oldImage;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  int? doctorId = sharedPreferences?.getInt('id');

  void getDcotor() async {
    doctor = (await DoctorApi().getDoctorById(doctorId!));
    specialization =
        (await ApiService().getSpecializationById(doctor!.specializationId));

    doctor != null
        ? firstNameController.text = doctor!.firstName
        : firstNameController.text = "";
    doctor != null
        ? lastNameController.text = doctor!.lastName
        : lastNameController.text = "";
    doctor != null
        ? emailController.text = doctor!.email
        : emailController.text = "";
    doctor != null
        ? phoneController.text = doctor!.phoneNumber
        : phoneController.text = "";
    doctor != null ? oldImage = doctor!.image : oldImage = "";
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    update();
  }

  void editDoctor(DoctorProfile doctorProfile) async {
    var response = await DoctorApi().editDoctor(doctorProfile);
    if (response['success'] == true) {
      // Navigate to home page on successful registration
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: 'Doctor edit successful',
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
  }

  void pickAndMoveImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      String appDirPath = 'F:\\fourth year Project\\Doctor\\doctor';
      // Move the image to the desired folder
      await File(pickedImage.path)
          .copy('$appDirPath\\images\\${path.basename(pickedImage.path)}');

      String imageName = pickedImage.name;
      doctor?.image = imageName;
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

  void unsaveImage() {
    doctor!.image = oldImage;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    doctor = null;
    specialization = null;
    getDcotor();
    update();
  }
}
