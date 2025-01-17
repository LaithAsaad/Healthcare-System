import 'package:flutter/src/widgets/navigator.dart';
import 'package:doctor/main.dart';
import 'package:get/get.dart';

class AuthMiddleWare extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    if(sharedPreferences?.getString('email')!=null) return const RouteSettings(name: '/bottomBarD');
    return null;
  }
}