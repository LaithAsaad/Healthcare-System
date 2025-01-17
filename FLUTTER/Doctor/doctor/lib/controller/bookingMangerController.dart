import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:doctor/data/api/booking_api.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/booking.dart';
import '../main.dart';

class BookingManagerController extends GetxController {
  late List<Booking>? bookings = [];
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  int? currentIndex;

  int? doctorId = sharedPreferences?.getInt('id');

  Future<void> addEvent(DateTime date, TimeOfDay time) async {
    String onlyDate = DateFormat('yyyy-MM-dd').format(date);
    DateTime booking = DateTime.parse(
        "$onlyDate ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000");
    Booking newBooking =
        Booking(doctorId: doctorId!, patientId: null, bookingDate: booking);

    if (bookings != null) {
      for (Booking b in bookings!) {
        if (DateFormat('yyyy-MM-dd').format(b.bookingDate) ==
            DateFormat('yyyy-MM-dd').format(date)) {
          if (booking.difference(b.bookingDate).abs() <
              const Duration(minutes: 30)) {
            Get.showSnackbar(const GetSnackBar(
              message:
                  'Booking time error: Minimum booking duration is 30 minutes.',
              duration: Duration(seconds: 5),
            ));
            return;
          }
        }
      }
    }
    var response = await BookingApi().addBooking(newBooking);
    if (response['success'] == true) {
      Get.showSnackbar(const GetSnackBar(
        message: 'Booking time add successful',
        duration: Duration(seconds: 3),
      ));
      var res = Booking.fromJson(jsonDecode(response['body']));
      bookings?.add(res);
    }
    update();
  }

  Future<void> deletebooking(int index) async {
    List<Booking> list = listOfDayEvents(selectedDay);
    Booking deleteBooking = list.elementAt(index);

    var response = await BookingApi().deleteBooking(deleteBooking);
    if (response['success'] == true) {
      Get.showSnackbar(const GetSnackBar(
        message: 'Booking time delete successful',
        duration: Duration(seconds: 3),
      ));
      bookings?.remove(deleteBooking);
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

  void getData() async {
    bookings = await BookingApi().getBookingByDoctorId(doctorId!);
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    update();
  }

  void changeIndex(int? index) {
    currentIndex = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    bookings = null;
    getData();
    update();
  }
}
