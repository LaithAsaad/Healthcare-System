import 'package:get/get.dart';
import '../data/api/spec_api.dart';
import '../data/models/specialization.dart';

class HomePageController extends GetxController{
  late List<Specialization>? specList = [];
  
  void getData() async {
    specList = (await SpecializationApi().getAllSpecAvailable());
    specList?.sort((a, b) => a.name.compareTo(b.name));
    update();
  }

  @override
  void onInit(){
    super.onInit();
    getData();
    update();
  }
}