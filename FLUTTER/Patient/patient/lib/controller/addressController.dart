import 'package:patient/data/models/address.dart';
import 'package:get/get.dart';
import '../data/api/address_api.dart';

class AddresController extends GetxController {
  AddresController(int id) {
    addressId = id;
  }
  late Address? address;
  int? addressId;
  void getAddres() async {
    address = (await AddressApi().getAddressById(addressId!));
    update();
  }

  @override
  void onInit() {
    super.onInit();
    address = null;
    getAddres();
    update();
  }
}
