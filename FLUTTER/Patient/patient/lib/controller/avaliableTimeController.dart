import 'package:patient/data/api/availableTime_api.dart';
import 'package:patient/data/models/availableTime.dart';
import 'package:get/get.dart';

class AvailableTimeController extends GetxController {
  AvailableTimeController(int id) {
    doctorId = id;
  }

  late List<AvailableTime>? availableTimeList = [];
  int? doctorId;

  void getData() async {
    availableTimeList =
        (await AvailableTimeApi().getAllAvailabeTime(doctorId!));
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
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

  @override
  void onInit() {
    super.onInit();
    getData();
    update();
  }
}
