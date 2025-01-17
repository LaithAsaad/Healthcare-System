import 'package:flutter/material.dart';
import 'package:doctor/data/models/login.dart';
import 'package:get/get.dart';

import '../../controller/authDoctorController.dart';

class LoginDoctor extends StatelessWidget {
  LoginDoctor({super.key});

  // final AuthDoctorController auth = Get.put(AuthDoctorController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthDoctorController auth = Get.put(AuthDoctorController());
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          "images/doctor.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
          width: double.infinity,
          height: double.infinity,
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: Get.mediaQuery.size.width * 0.34),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Connect",
                          style: TextStyle(
                            fontSize: Get.mediaQuery.size.width * 0.16,
                            color: const Color.fromARGB(255, 197, 197, 197),
                            fontFamily: "Kalam",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: Get.mediaQuery.size.width * 0.44),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Health",
                          style: TextStyle(
                            fontSize: Get.mediaQuery.size.width * 0.16,
                            color: Get.theme.primaryColor,
                            fontFamily: "Kalam",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            controller: auth.emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!isValidEmail(
                                  auth.emailController.text)) {
                                return 'Your Email is not vaild';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Get.theme.primaryColor,
                                        width: 2)),
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                hintText:
                                    'Enter valid mail id as abc@gmail.com'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        GetBuilder<AuthDoctorController>(
                          //init: AuthDoctorController(),
                          builder: (controller) => Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              controller: controller.passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              obscureText: controller.obscureText,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.showHidePassword();
                                    },
                                    icon: Icon(
                                      controller.obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Get.theme.primaryColor,
                                          width: 2)),
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  hintText: 'Enter your secure password'),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(15),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );

                                  LogInModel user = LogInModel(
                                      email: auth.emailController.text,
                                      password: auth.passwordController.text);
                                  auth.userLogIn(user);
                                  //Navigator.of(context).pushReplacementNamed("homePage");
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Error in Data')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10),
                                  backgroundColor: Get.theme.primaryColor,
                                  textStyle: const TextStyle(fontSize: 20)),
                              child: const Text("Log in"),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(1),
                            // ignore: prefer_const_literals_to_create_immutables
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Don't have an account yet? ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.offNamed('signupD');
                                  },
                                  child: Text(
                                    "Sign up now",
                                    style: TextStyle(
                                        color: Get.theme.primaryColor),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}
