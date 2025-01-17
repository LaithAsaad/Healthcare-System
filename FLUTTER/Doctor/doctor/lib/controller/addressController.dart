import 'package:flutter/cupertino.dart';
import 'package:doctor/data/models/address.dart';

import 'package:get/get.dart';

import '../data/api/address_api.dart';
import '../main.dart';

class AddresController extends GetxController {
  TextEditingController cityController = TextEditingController();
  TextEditingController governorateController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  late Address? address;
  int? addressId = sharedPreferences?.getInt('id');
  void getAddres() async {
    address = (await AddressApi().getAddressById(addressId!));

    address != null
        ? cityController.text = address!.city
        : cityController.text = "";
    address != null
        ? governorateController.text = address!.governorate
        : governorateController.text = "";
    address != null
        ? streetController.text = address!.street
        : streetController.text = "";
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    update();
  }

  void addAddress(Address address) async {
    var response = await AddressApi().addAddress(address);
    if (response['success'] == true) {
      // Navigate to home page on successful registration
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: 'Address edit successful',
        duration: Duration(seconds: 3),
      ));
    } else {
      // Display error message
      // Get.defaultDialog(
      //   confirm: TextButton(
      //     onPressed: () => Get.back(),
      //     child: Text('OK'),
      //   ),
      //   titlePadding: EdgeInsets.only(top: 20),
      //   contentPadding: EdgeInsets.all(20),
      //   titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      //   title: 'Error!',
      //   content: Text('${response['error']}'),
      //);
    }
  }

  @override
  void onInit() {
    super.onInit();
    address = null;
    getAddres();
    update();
  }
}
