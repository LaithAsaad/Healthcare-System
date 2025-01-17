import 'package:flutter/material.dart';
import 'package:patient/data/api/booking_api.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient/data/models/doctor_booking.dart';
import 'package:patient/main.dart';

import '../data/models/booking.dart';

//import '../home/list.dart';

class BookingManagerController extends GetxController {
  late List<DoctorBooking>? bookings = [];
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  int? patientId = sharedPreferences?.getInt('id');

  Future<void> deleteBookingByPatient(int index) async {
    List<DoctorBooking> list = listOfDayEvents(selectedDay);
    DoctorBooking doctorBooking = list.elementAt(index);
    Booking deleteBooking = Booking(
        id: doctorBooking.id,
        doctorId: doctorBooking.doctorId,
        patientId: null,
        bookingDate: doctorBooking.bookingDate);

    var response = await BookingApi().bookingByPatient(deleteBooking);
    if (response['success'] == true) {
      Get.showSnackbar(const GetSnackBar(
        message: 'Booking time delete successful',
        duration: Duration(seconds: 3),
      ));
      bookings?.remove(doctorBooking);
    } else {
      // Display error message
      Get.defaultDialog(
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding: const EdgeInsets.all(20),
        titleStyle:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        title: 'Error!',
        content: Text(
          '${response['error']}',
          textAlign: TextAlign.center,
        ),
      );
    }
    update();
  }

  String getDoctorName(int index) {
    List<DoctorBooking> list = listOfDayEvents(selectedDay);
    DoctorBooking doctorBooking = list.elementAt(index);

    return "Dr. ${doctorBooking.firstName} ${doctorBooking.lastName}";
  }

  List<DoctorBooking> listOfDayEvents(DateTime dateTime) {
    List<DoctorBooking> currentDateBooking = [];
    if (bookings != null) {
      for (DoctorBooking booking in bookings!) {
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

  void getBooking() async {
    bookings = await BookingApi().getBooking(patientId!);
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    update();
  }

  @override
  void onInit() {
    super.onInit();
    bookings = null;
    getBooking();
    update();
  }
}
