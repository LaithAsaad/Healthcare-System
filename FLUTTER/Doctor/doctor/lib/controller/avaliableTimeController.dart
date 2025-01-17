import 'package:flutter/material.dart';
import 'package:doctor/data/api/availableTime_api.dart';
import 'package:doctor/data/models/availableTime.dart';
import 'package:doctor/main.dart';
import 'package:get/get.dart';

class AvailableTimeController extends GetxController {
  bool isAvailable = true;
  int currentIndex = 1;

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  late List<AvailableTime>? availableTimeList = [];
  AvailableTime? currentTime;
  int? doctorId = sharedPreferences?.getInt('id');

  void getData() async {
    availableTimeList =
        (await AvailableTimeApi().getAllAvailabeTime(doctorId!));
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    update();
    search(1);
  }

  void search(int index) {
    currentTime = availableTimeList
        ?.firstWhereOrNull((element) => element.dayId == index);
    isAvailable = currentTime != null ? currentTime!.isAvailable : true;

    currentTime != null
        ? startTimeController.text =
            '${currentTime!.startTime.hour.toString().padLeft(2, '0')}:${currentTime!.startTime.minute.toString().padLeft(2, '0')}'
        : startTimeController.text = "";
    currentTime != null
        ? endTimeController.text =
            '${currentTime!.endTime.hour.toString().padLeft(2, '0')}:${currentTime!.endTime.minute.toString().padLeft(2, '0')}'
        : endTimeController.text = "";
    currentTime != null
        ? currentTime?.isAvailable == false
            ? reasonController.text = currentTime!.reasonOfUnavilability!
            : reasonController.text = ""
        : reasonController.text = "";
  }

  void editAvailableTime(AvailableTime availableTime) {
    var a = availableTimeList
        ?.firstWhereOrNull((element) => element.dayId == availableTime.dayId);
    availableTimeList?.remove(a);
    availableTimeList?.add(availableTime);
    update();
    search(availableTime.dayId);
  }

  void addAvailableTime(AvailableTime availableTime) async {
    var response = await AvailableTimeApi().addAvailableTime(availableTime);
    if (response['success'] == true) {
      // Navigate to home page on successful registration
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: 'Available time edit successful',
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

  void deleteAvailableTime(int id) async {
    var response = await AvailableTimeApi().deleteAvailableTime(id);
    if (response['success'] == true) {
      // Navigate to home page on successful registration
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: 'Available time deleted successful',
        duration: Duration(seconds: 3),
      ));
    }
  }

  void editAvailableTimeAfterDelete(int id) {
    var a = availableTimeList?.firstWhereOrNull((element) => element.id == id);
    availableTimeList?.remove(a);
    reasonController.text = "";
    endTimeController.text = "";
    startTimeController.text = "";
    update();
  }

  String getDay(int dayId) {
    switch (dayId) {
      case 1:
        return 'Saturday';
      case 2:
        return 'Sunday';
      case 3:
        return 'Monday';
      case 4:
        return 'Tuesday';
      case 5:
        return 'Wednesday';
      case 6:
        return 'Thursday';
      case 7:
        return 'Friday';
      default:
        return '';
    }
  }

  void setStartTime(TimeOfDay time) {
    startTimeController.text =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    update();
  }

  void setEndTime(TimeOfDay time) {
    endTimeController.text =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    update();
  }

  bool validEndTime() {
    int startHour =int.parse(startTimeController.text.substring(0, 2));
    int endHour =int.parse(endTimeController.text.substring(0, 2));
    int startRange = startHour + 2 == 24 ? 0 : startHour + 2;
    int endRange = startHour + 4 == 24 ? 0 : startHour + 4;
    if (endHour <= endRange && endHour >= startRange) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getData();
    update();
  }

  void changeIndex(int x) {
    currentIndex = x + 1;
    update();
  }

  void changeAvailable() {
    isAvailable = !isAvailable;
    update();
  }
}
