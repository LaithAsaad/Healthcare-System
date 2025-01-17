import 'package:flutter/material.dart';
import 'package:doctor/screen/bottomNavigationBarD.dart';
import 'package:doctor/middleware/auth.dart';
import 'package:doctor/screen/chatDetailPage.dart';
import 'package:get/get.dart';
import 'package:doctor/screen/auth/loginDoctor.dart';
import 'package:doctor/screen/auth/signupDoctor.dart';
import 'package:doctor/screen/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/avaliableTime.dart';
import 'screen/patientProfile.dart';

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
        primaryColor: const Color.fromRGBO(24, 168, 141, 1)
          // primaryColor: const Color.fromARGB(255 	,24 ,	156,168)
          ),
      initialRoute: '/loginD',
      // home: BookingPage(),
      getPages: [
        GetPage(name: '/signupD', page: () => SignUpDoctor(),middlewares: [AuthMiddleWare()]),
        GetPage(name: '/loginD', page: () => LoginDoctor(),middlewares: [AuthMiddleWare()]),
        GetPage(name: '/homePage', page: () => const MyHomePage()),
        GetPage(name: '/availableTime', page: () => const AvailableTimePage(),),
        GetPage(name: '/bottomBarD', page: () =>  const BottomNavigationBarDoctor(),),
        GetPage(name: '/PatientProfile', page: () =>  const PatientProfilePage(),),
        GetPage(name: '/chatDetailPage', page: () =>  ChatDetailPage(),),
      ],
    );
  }
}
