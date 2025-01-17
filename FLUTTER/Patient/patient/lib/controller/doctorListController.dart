import 'package:get/get.dart';
import 'package:patient/data/api/doctor_api.dart';
import 'package:patient/data/models/doctor_address.dart';

import '../data/models/specialization.dart';

class DoctorListController extends GetxController {
  late Specialization specialization;

  late List<DoctorAddress>? doctorsDetails;

  void getData() async {
    details = (await DcotorApi().getDoctorWithAddress(specialization.id));
    doctorsDetails = details;
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    update();
  }

  late List<DoctorAddress>? details = [];

  final List<String> citys = [
    "All",
    "Damascus",
    "Aleppo",
    "Homs",
    "Hamah",
    "Tartous",
    "Latakia",
    "Quneitra",
    "Raqqa",
    "Deir ez-Zor",
    "Rif Dimashq",
    "Daraa",
    "Al-Suwayda",
    "Al-Hasakah",
    "Idlib"
  ];
  bool male = false;
  bool female = false;
  bool both = true;
  bool allAges = true;
  bool youngAdults = false;
  bool middleAgedAdults = false;
  bool oldAdults = false;
  String? selectedItem = "All";

  List<DoctorAddress>? getDoctor(List<DoctorAddress> list) {
    List<DoctorAddress>? filter = list;
    List<DoctorAddress>? youngHelper = [];
    List<DoctorAddress>? middleHelper = [];
    List<DoctorAddress>? oldHelper = [];
    if (selectedItem != "All") {
      filter = list
          .where((element) =>
              element.city.toLowerCase().contains(selectedItem!.toLowerCase()))
          .toList();
    }
    if (both != true) {
      if (female == true) {
        filter = filter.where((element) => element.gender == false).toList();
      } else {
        filter = filter.where((element) => element.gender == true).toList();
      }
    }
    if (allAges != true) {
      if (youngAdults == true) {
        youngHelper = filter
            .where((element) =>
                int.parse(calculateAge(element.birthDate)) >= 30 &&
                int.parse(calculateAge(element.birthDate)) < 40)
            .toList();
      }
      if (middleAgedAdults == true) {
        middleHelper = filter
            .where((element) =>
                int.parse(calculateAge(element.birthDate)) >= 40 &&
                int.parse(calculateAge(element.birthDate)) < 55)
            .toList();
      }
      if (oldAdults == true) {
        oldHelper = filter
            .where(
                (element) => int.parse(calculateAge(element.birthDate)) >= 55)
            .toList();
      }
      return youngHelper + middleHelper + oldHelper;
    }
    return filter;
  }

  void onCahngeMale(var val) {
    val != null ? male = val : false;
    ((male == true) && (female == true))
        ? {both = true, male = false, female = false}
        : false;
    if (male == false) {
      both = false;
    }
    if (male == true && both == true && female == false) {
      both = false;
    }
    if (male == false && both == false && female == false) {
      both = true;
    }
    doctorsDetails = getDoctor(details!);
    update();
  }

  void onCahngeFemale(var val) {
    val != null ? female = val : false;
    ((male == true) && (female == true))
        ? {both = true, male = false, female = false}
        : false;
    if (female == false) {
      both = false;
    }
    if (female == true && both == true && male == false) {
      both = false;
    }
    if (male == false && both == false && female == false) {
      both = true;
    }
    doctorsDetails = getDoctor(details!);
    update();
  }

  void onCahngeBoth(var val) {
    if (val != null) {
      if (male == false && val == false && female == false) {
        both = true;
      } else if (val == true && (male == false || female == false)) {
        male = false;
        female = false;

        both = true;
      } else {
        both = val;
      }
    } else {
      both = false;
    }
    doctorsDetails = getDoctor(details!);
    update();
  }

  void chooseCity(var val) {
    selectedItem = val;
    doctorsDetails = getDoctor(details!);
    update();
  }

  void onChangeAllAge(var val) {
    if (val != null) {
      if (youngAdults == false &&
          middleAgedAdults == false &&
          val == false &&
          oldAdults == false) {
        allAges = true;
      } else if (val == true &&
          (oldAdults == false ||
              youngAdults == false ||
              middleAgedAdults == false)) {
        youngAdults = false;
        oldAdults = false;
        middleAgedAdults = false;
        allAges = true;
      } else {
        allAges = val;
      }
    } else {
      allAges = false;
    }
    doctorsDetails = getDoctor(details!);
    update();
  }

  void onChangeYoungAdults(var val) {
    val != null ? youngAdults = val : false;
    youngAdults == true && middleAgedAdults == true && oldAdults == true
        ? {
            allAges = true,
            youngAdults = false,
            middleAgedAdults = false,
            oldAdults = false
          }
        : false;
    if (youngAdults == false) {
      allAges = false;
    }
    if (oldAdults == false &&
        allAges == true &&
        youngAdults == true &&
        middleAgedAdults == false) {
      allAges = false;
    }
    if (youngAdults == false &&
        middleAgedAdults == false &&
        allAges == false &&
        oldAdults == false) {
      allAges = true;
    }
    doctorsDetails = getDoctor(details!);
    update();
  }

  void onChangeMiddleAgedAdults(var val) {
    val != null ? middleAgedAdults = val : false;
    youngAdults == true && middleAgedAdults == true && oldAdults == true
        ? {
            allAges = true,
            youngAdults = false,
            middleAgedAdults = false,
            oldAdults = false
          }
        : false;
    if (middleAgedAdults == false) {
      allAges = false;
    }
    if (oldAdults == false &&
        allAges == true &&
        youngAdults == false &&
        middleAgedAdults == true) {
      allAges = false;
    }
    if (youngAdults == false &&
        middleAgedAdults == false &&
        allAges == false &&
        oldAdults == false) {
      allAges = true;
    }
    doctorsDetails = getDoctor(details!);
    update();
  }

  void onChangeOldAdults(var val) {
    val != null ? oldAdults = val : false;
    youngAdults == true && middleAgedAdults == true && oldAdults == true
        ? {
            allAges = true,
            youngAdults = false,
            middleAgedAdults = false,
            oldAdults = false
          }
        : false;
    if (oldAdults == false) {
      allAges = false;
    }
    if (oldAdults == true &&
        allAges == true &&
        youngAdults == false &&
        middleAgedAdults == false) {
      allAges = false;
    }
    if (youngAdults == false &&
        middleAgedAdults == false &&
        allAges == false &&
        oldAdults == false) {
      allAges = true;
    }
    doctorsDetails = getDoctor(details!);
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
    specialization = Get.arguments as Specialization;
    getData();
    doctorsDetails = details;
    super.onInit();
  }
}
