import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homePageController.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // @override
  // State<MyHomePage> createState() => _MyHomePageState();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = Get.mediaQuery;
    final screenWidth = mediaQuery.size.width;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Specialization"),
          centerTitle: true,
          backgroundColor: Get.theme.primaryColor),
      body: GetBuilder<HomePageController>(
        init: HomePageController(),
        builder: (controller) => controller.specList == null ||
                controller.specList!.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Get.theme.primaryColor,
                ),
              )
            : GridView.builder(
                itemCount: controller.specList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) => InkWell(
                  splashColor: Colors.white,
                  onTap: () async {
                    //controller.getData();
                    //print(controller.specList![0].name);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurStyle: BlurStyle.outer,
                            blurRadius: 2.0,
                            spreadRadius: 0.5,
                          )
                        ],
                        color: Get.theme.primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                                "images/${controller.specList![index].image}"),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              controller.specList![index].name,
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

// class _MyHomePageState extends State<MyHomePage> {
//   //late List<Specialization>? _specList = [];
//  // HomePageController homePageController = Get.put(HomePageController());
//   @override
//   void initState() {
//     super.initState();
//     //fetchData();
//   }

//   // void _getData() async {
//   //   _specList = (await ApiService().getAllSpecAvailable())!;
//   //   Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
//   // }

//   List<Map> name = [
//     {"name": "Endocrinologist", "icon": "endocrine(2).png"},
//     {"name": "Dentist", "icon": "tooth.png"},
//     {"name": "Cardiologists", "icon": "heart.png"},
//     {"name": "Dermatology", "icon": "dermatology.png"},
//     {"name": "Gastroenterology", "icon": "stomach.png"},
//     {"name": "Nephrology", "icon": "kidney.png"},
//     {"name": "Hematology", "icon": "blood.png"},
//     {"name": "Neurology", "icon": "neuron.png"},
//     {"name": "Obstetrics and Gynecology", "icon": "baby.png"},
//     {"name": "Ophthalmology", "icon": "eyeball.png"},
//     // {
//     //   "name" : "Orthopedics",
//     //   "icon" : "joint.png"
//     // },
//     // {
//     //   "name" : "Pediatrics",
//     //   "icon" : "baby-boy.png"
//     // },
//     // {
//     //   "name" : "Pulmonology",
//     //   "icon" : "pulmonology.png"
//     // },
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text("Specialization"),
//           backgroundColor: Get.theme.primaryColor),
//       drawer: Drawer(
//         child: Column(
//           children: [
//             UserAccountsDrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Get.theme.primaryColor,
//                 ),
//                 currentAccountPicture: const CircleAvatar(
//                   //backgroundImage: AssetImage("images/4.jpg"),
//                   backgroundColor: Color.fromRGBO(24, 168, 141, 1),
//                 ),
//                 accountName: const Text("laith"),
//                 accountEmail: const Text("laith@gmail.com")),
//             ListTile(
//               title: const Text("Home Page"),
//               leading: const Icon(Icons.home_outlined),
//               onTap: () {
//                 //Navigator.pushNamed(context, 'login');
//               },
//             ),
//             ListTile(
//               title: const Text("Help"),
//               leading: const Icon(Icons.help_outline),
//               onTap: () {
//                 //Navigator.pushNamed(context, 'login');
//               },
//             ),
//             ListTile(
//               title: const Text("Contact Us"),
//               leading: const Icon(Icons.contact_support),
//               onTap: () {
//                 //Navigator.pushNamed(context, 'login');
//               },
//             ),
//             ListTile(
//               title: const Text("About"),
//               leading: const Icon(Icons.info_outline),
//               onTap: () {
//                 //Navigator.pushNamed(context, 'login');
//               },
//             ),
//             ListTile(
//               title: const Text("Log Out"),
//               leading: const Icon(Icons.logout_outlined),
//               onTap: () {
//                 Get.offAll('loginP');
//               },
//             )
//           ],
//         ),
//       ),
//       body: GetBuilder<HomePageController>(
//         init: HomePageController(),
//         builder: (controller) => controller.specList == null ||
//                 controller.specList!.isEmpty
//             ? Column(
//                 children: [
//                   Center(
//                     child: CircularProgressIndicator(
//                       color: Get.theme.primaryColor,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.abc),
//                     onPressed: () => (),
//                   )
//                 ],
//               )
//             : GridView.builder(
//                 itemCount: controller.specList!.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 3 / 2,
//                 ),
//                 itemBuilder: (context, index) => InkWell(
//                   splashColor: Colors.white,
//                   onTap: () async {
//                     controller.getData();
//                     //print(controller.specList![0].name);
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         boxShadow: const [
//                           BoxShadow(
//                             blurStyle: BlurStyle.outer,
//                             blurRadius: 2.0,
//                             spreadRadius: 0.5,
//                           )
//                         ],
//                         color: Get.theme.primaryColor,
//                         borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(50),
//                             bottomRight: Radius.circular(50),
//                             topRight: Radius.circular(10),
//                             bottomLeft: Radius.circular(10))),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//                         children: [
//                           Expanded(
//                               child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Image.asset(
//                                 "images/${controller.specList![index].image}"),
//                           )),
//                           Expanded(
//                               child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text(
//                               textAlign: TextAlign.center,
//                               controller.specList![index].name,
//                               style: const TextStyle(
//                                   color: Colors.white, fontSize: 18),
//                             ),
//                           )),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
