import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/controller/doctorListController.dart';
import 'package:patient/controller/sendMessageController.dart';
import '../data/models/doctor_address.dart';

class DcotorList extends StatelessWidget {
  final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

  DcotorList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _mainScaffoldKey,
      appBar: AppBar(
        title: GetBuilder<DoctorListController>(
          init: DoctorListController(),
          builder: (controller) => Text(controller.specialization.name,
              style: const TextStyle(
                color: Colors.white,
              )),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search());
              },
              icon: const Icon(Icons.search, color: Colors.white)),
          IconButton(
              onPressed: () => _mainScaffoldKey.currentState?.openEndDrawer(),
              icon: const Icon(Icons.filter_list_sharp, color: Colors.white))
        ],
      ),
      endDrawer: GetBuilder<DoctorListController>(
        init: DoctorListController(),
        builder: (controller) => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
              ),
              child: const Text('Filter Options',
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ),
            Column(
              children: [
                const Text(
                  "Choose Gender",
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Image(image: AssetImage("images/male.png")),
                          Checkbox(
                              value: controller.male,
                              onChanged: (val) {
                                controller.onCahngeMale(val);
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Image(image: AssetImage("images/female.png")),
                          Checkbox(
                              value: controller.female,
                              onChanged: (val) {
                                controller.onCahngeFemale(val);
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Image(
                              image: AssetImage("images/collaboration.png")),
                          Checkbox(
                              value: controller.both,
                              onChanged: (val) {
                                controller.onCahngeBoth(val);
                              })
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    "Choose City",
                    style: TextStyle(fontSize: 20),
                  ),
                  DropdownSearch<String>(
                    popupProps: const PopupProps.menu(showSelectedItems: true),
                    items: controller.citys,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          labelText: "City",
                          focusColor: Get.theme.primaryColor,
                          hoverColor: Get.theme.primaryColor,
                          fillColor: Colors.white,
                          filled: true),
                    ),
                    onChanged: (String? val) {
                      controller.chooseCity(val);
                    },
                    selectedItem: controller.selectedItem,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text("Choose Age", style: TextStyle(fontSize: 20)),
                  CheckboxListTile(
                    title: const Text("All"),
                    subtitle: const Text(
                      "All Groups",
                      style: TextStyle(fontSize: 10, color: Colors.blueAccent),
                    ),
                    secondary: const Icon(Icons.groups),
                    isThreeLine: true,
                    value: controller.allAges,
                    onChanged: (val) {
                      controller.onChangeAllAge(val);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("30-40"),
                    subtitle: const Text(
                      "Young",
                      style: TextStyle(fontSize: 10, color: Colors.blueAccent),
                    ),
                    secondary: const Icon(Icons.star_border_outlined),
                    isThreeLine: true,
                    value: controller.youngAdults,
                    onChanged: (val) {
                      controller.onChangeYoungAdults(val);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("40-55"),
                    subtitle: const Text(
                      "Specialist",
                      style: TextStyle(fontSize: 10, color: Colors.blueAccent),
                    ),
                    secondary: const Icon(Icons.star_half_outlined),
                    isThreeLine: true,
                    value: controller.middleAgedAdults,
                    onChanged: (val) {
                      controller.onChangeMiddleAgedAdults(val);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("More Than 55"),
                    subtitle: const Text(
                      "Expert",
                      style: TextStyle(fontSize: 10, color: Colors.blueAccent),
                    ),
                    secondary: const Icon(Icons.star_outlined),
                    isThreeLine: true,
                    value: controller.oldAdults,
                    onChanged: (val) {
                      controller.onChangeOldAdults(val);
                    },
                  )
                ],
              ),
            )
          ]),
        ),
      ),
      body: GetBuilder<DoctorListController>(
        init: DoctorListController(),
        builder: (controller) => controller.doctorsDetails == null ||
                controller.doctorsDetails!.isEmpty
            ? SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Expanded(
                      flex: 3,
                      child: Lottie.asset('images/data2.json'),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          'No Doctor Available',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ]))
            : ListView.builder(
                key: UniqueKey(),
                itemCount: controller.doctorsDetails?.length,
                itemBuilder: (context, index) {
                  return doctorList(context, controller.doctorsDetails, index);
                },
              ),
      ),
    );
  }
}

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GetBuilder<DoctorListController>(
        init: DoctorListController(),
        builder: (controller) {
          List<DoctorAddress>? availableDoctors = controller.doctorsDetails
              ?.where((element) =>
                  element.firstName
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  element.lastName
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  element.city.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return availableDoctors == null || availableDoctors.isEmpty
              ? SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Expanded(
                        flex: 3,
                        child: Lottie.asset('images/data2.json'),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'No Doctor Available',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ]))
              : ListView.builder(
                  itemCount: query == ""
                      ? controller.doctorsDetails?.length
                      : availableDoctors.length,
                  itemBuilder: (context, index) {
                    return doctorList(context, availableDoctors, index);
                  },
                );
        });
  }
}

Container doctorList(
    BuildContext context, List<DoctorAddress>? list, int index) {
  final mediaQuery = Get.mediaQuery;
  final screenWidth = mediaQuery.size.width;
  final fontSize = screenWidth * 0.04;
  return Container(
    margin: const EdgeInsets.all(7),
    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Flexible(
          flex: 6,
          child: ListTile(
            tileColor: Get.theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(50.0)),
              side: BorderSide(color: Get.theme.primaryColor),
            ),
            onTap: () {
              Get.defaultDialog(
                title: "Dr. ${list[index].firstName} ${list[index].lastName}",
                cancel: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GetBuilder(
                          init: SendMessageController(),
                          builder: (controller) => IconButton(
                              onPressed: () {
                                Get.back();
                                controller.sendMessageToDoctor(
                                    list[index].id,
                                    list[index].firstName,
                                    list[index].lastName,
                                    list[index].image);
                              },
                              icon: Icon(
                                Icons.message,
                                color: Get.theme.primaryColor,
                              )),
                        ),
                        const Text("Chat")
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                              Get.toNamed('/booking',
                                  arguments: list[index].id);
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: Get.theme.primaryColor,
                            )),
                        const Text('Booking')
                      ],
                    ),
                  ],
                ),
              );
            },
            leading: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: list?[index].image == null
                  ? const AssetImage('images/unknown.jpg')
                  : AssetImage('images/${list?[index].image}'),
            ),
            textColor: Colors.white,
            title: Text(
              "Dr. ${list?[index].firstName} ${list?[index].lastName}",
              style: TextStyle(fontSize: fontSize+2,fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
                "${DoctorAddress.calculateAge(list![index].birthDate)}  ${list[index].gender == true ? 'Male' : 'Female'}  ${list[index].city}",
                style: const TextStyle(fontSize: 10)),
            trailing: IconButton(
              icon: const Icon(Icons.info_rounded),
              color: Colors.white,
              onPressed: () {
                Get.toNamed('/doctorProfile', arguments: list[index].id);
              },
            ),
          )),
    ]),
  );
}
