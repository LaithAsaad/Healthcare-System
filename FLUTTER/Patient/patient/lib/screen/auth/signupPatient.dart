import 'package:flutter/material.dart';
import 'package:patient/controller/authPatientController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/patient.dart';
// ignore_for_file: prefer_const_constructors

class SignUpPatient extends StatelessWidget {
  SignUpPatient({super.key});

  final _formKey = GlobalKey<FormState>();
  //AuthPatientController auth = Get.put(AuthPatientController());

  @override
  Widget build(BuildContext context) {
    final AuthPatientController auth = Get.put(AuthPatientController());
    return Scaffold(
      //appBar: AppBar(backgroundColor: Get.theme.primaryColor,),
      body: Stack(children: [
        Image.asset(
          "images/patient.png",
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
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            maxLength: 20,
                            controller: auth.firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Get.theme.primaryColor,
                                        width: 2)),
                                labelText: 'First Name',
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                hintText: 'Enter your first name'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            maxLength: 20,
                            controller: auth.lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Get.theme.primaryColor,
                                        width: 2)),
                                labelText: 'Last Name',
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                hintText: 'Enter your last name'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            maxLength: 10,
                            controller: auth.phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              } else if (!isValidPhoneNumber(
                                  auth.phoneController.text)) {
                                return 'Please enter a vaild syrain phone number (09........)';
                              }
                              //else if()
                              return null;
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Get.theme.primaryColor,
                                        width: 2)),
                                labelText: 'Phone Number',
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                hintText: 'Enter your phone number'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
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
                        GetBuilder<AuthPatientController>(
                          //init: AuthPatientController(),
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
                        GetBuilder<AuthPatientController>(
                          builder: (controller) => Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              controller: controller.conController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please re-enter your password.';
                                } else if (value !=
                                    auth.passwordController.text) {
                                  return 'Your confirmation password do not match your password.';
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
                                  labelText: 'Confirm Password',
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  hintText: 'Re-enter your secure password'),
                            ),
                          ),
                        ),
                       GetBuilder<AuthPatientController>(
                          builder: (controller) => Padding(
                            padding: const EdgeInsets.all(6),
                            child: TextButton(
                              onLongPress: () {
                                Get.defaultDialog(
                                  title: 'Delete Birth Date',
                                  content: Text('Do you wnat to delete it?'),
                                  cancel: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Get.theme.primaryColor)),
                                    onPressed: () => Get.back(),
                                    child: Text('Cancel'),
                                  ),
                                  confirm: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red)),
                                    onPressed: () {
                                      controller.birthDateController.text = '';
                                      Get.back();
                                    },
                                    child: Text('Delete'),
                                  ),
                                );
                              },
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now(),
                                    firstDate: DateTime(
                                        1950), 
                                    lastDate: DateTime(2030),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Get.theme
                                                .primaryColor, // <-- SEE HERE
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    });
                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  controller.setBirthDate(formattedDate);
                                }
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: controller.birthDateController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your birth date';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red)),
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.white,
                                  )),
                                  labelText: 'Birth Date',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(15),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );

                                  Patient patient = Patient(
                                    firstName: auth.firstNameController.text,
                                    lastName: auth.lastNameController.text,
                                    phoneNumber: auth.phoneController.text,
                                    email: auth.emailController.text,
                                    password: auth.passwordController.text,
                                    confirmPassword: auth.conController.text,
                                    birthDate: DateTime.parse(
                                        "${auth.birthDateController.text} 00:00:00"),
                                  );
                                  auth.addPatient(patient);
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
                              child: const Text("Sign up"),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(1),
                            // ignore: prefer_const_literals_to_create_immutables
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.offNamed('loginP');
                                  },
                                  child: Text(
                                    "Log in now",
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

bool isValidPhoneNumber(String phoneNumber) {
  return RegExp(r'^0[0-9]{9}$').hasMatch(phoneNumber);
}
