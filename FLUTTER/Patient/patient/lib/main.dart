import 'package:flutter/material.dart';
import 'package:patient/screen/bottomNavigationBarP.dart';
import 'package:patient/screen/chatDetailPage.dart';
import 'package:patient/screen/doctorList.dart';
import 'package:patient/middleware/auth.dart';
import 'package:get/get.dart';
import 'package:patient/screen/auth/loginPatient.dart';
import 'package:patient/screen/auth/signupPatient.dart';
import 'package:patient/screen/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/booking.dart';
import 'screen/doctorProfile.dart';
import 'screen/success_booked.dart';

SharedPreferences? sharedPreferences;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const HealthCareApp());
}

class HealthCareApp extends StatelessWidget {
  const HealthCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primaryColor: const Color.fromRGBO(24, 168, 141, 1)
          primaryColor: const Color.fromARGB(255 	,24 ,	156,168)
          ),
      initialRoute: '/loginP',
      //home: ChatList(),
      getPages: [
        GetPage(name: '/signupP', page: () => SignUpPatient()),
        GetPage(name: '/loginP', page: () => LoginPatient(),middlewares: [AuthMiddleWare()]),
        GetPage(name: '/homePage', page: () => const MyHomePage()),
        GetPage(name: '/booking', page: () => const BookingPage()),
        GetPage(name: '/successBooked', page: () => const AppointmentBooked()),
        GetPage(name: '/bottomBarP', page: () =>  const BottomNavigationBarPatient(),),
        GetPage(name: '/doctorList', page: () =>  DcotorList(),),
        GetPage(name: '/doctorProfile', page: () =>  const DoctorProfile(),),
        GetPage(name: '/chatDetailPage', page: () =>   ChatDetailPage(),),
      ],
    );
  }
}
