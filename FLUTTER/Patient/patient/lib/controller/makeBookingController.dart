import 'package:flutter/material.dart';
import 'package:patient/data/api/booking_api.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient/main.dart';
import '../data/models/booking.dart';


class BookingManagerController extends GetxController {
  late List<Booking>? bookings = [];
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  int? currentIndex;
  late int doctorId;

  Future<void> bookingByPatient() async {
    if (currentIndex != null) {
      List<Booking> list = listOfDayEvents(selectedDay);
      Booking patientBooking = list.elementAt(currentIndex!);
      patientBooking.patientId = sharedPreferences?.getInt('id');

      var response = await BookingApi().bookingByPatient(patientBooking);
      if (response['success'] == true) {
        Get.toNamed('/successBooked');
        bookings?.remove(patientBooking);
      } else {
        // Display error message
        Get.defaultDialog(
          confirm: TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
          titlePadding: const EdgeInsets.only(top: 20),
          contentPadding: const EdgeInsets.all(20),
          titleStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          title: 'Error!',
          content: Text(
            '${response['error']}',
            textAlign: TextAlign.center,
          ),
        );
      }
    }
    update();
  }

  List<Booking> listOfDayEvents(DateTime dateTime) {
    List<Booking> currentDateBooking = [];
    if (bookings != null) {
      for (Booking booking in bookings!) {
        if (DateFormat('yyyy-MM-dd').format(booking.bookingDate) ==
            DateFormat('yyyy-MM-dd').format(dateTime)) {
          currentDateBooking.add(booking);
        }
      }
      return currentDateBooking;
    } else {
      return [];
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.focusedDay = focusedDay;
    this.selectedDay = selectedDay;
    update();
  }

  void getAvailableBooking() async {
    bookings = await BookingApi().getAvailableBooking(doctorId);
    update();
  }

  void changeIndex(int? index) {
    currentIndex = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    doctorId = Get.arguments as int;
    bookings = null;
    getAvailableBooking();
    update();
  }
}
