import 'package:get/get.dart';

import '../data/api/spec_api.dart';
import '../data/models/specialization.dart';

class HomePageController extends GetxController{
  late List<Specialization>? specList = [];
  
  void getData() async {
    specList = (await ApiService().getAllSpecAvailable());
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    update();
  }

  @override
  void onInit(){
    super.onInit();
    getData();
    update();
  }
}