import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/addressController.dart';
import '../../controller/avaliableTimeController.dart';
import '../../controller/profileDoctorController.dart';
import '../../data/models/address.dart';
import '../../data/models/doctorProfile.dart';
import '../../main.dart';

final _formKey = GlobalKey<FormState>();

dynamic availableTimeInfo() {
  Get.defaultDialog(
      cancel: ElevatedButton(
        style:
            const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
      title: 'Available Time',
      content: GetBuilder<AvailableTimeController>(
          init: AvailableTimeController(),
          builder: (controller) => controller.availableTimeList == null ||
                  controller.availableTimeList!.isEmpty
              ? const Text('The doctor does not have available times')
              : SizedBox(
                  width: Get.width / 2,
                  height: Get.height / 3,
                  // width: MediaQuery.of(context).size.height / 3,
                  // height: MediaQuery.of(context).size.height / 4,
                  child: ListView.builder(
                      itemCount: controller.availableTimeList?.length,
                      itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Get.theme.primaryColor),
                            ),
                            child: Column(children: [
                              Text(
                                  controller.getDay(controller.availableTimeList![index].dayId),
                                  style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "From: ${controller.availableTimeList![index].startTime.hour.toString().padLeft(2, '0')}:${controller.availableTimeList![index].startTime.minute.toString().padLeft(2, '0')} To: ${controller.availableTimeList![index].endTime.hour.toString().padLeft(2, '0')}:${controller.availableTimeList![index].endTime.minute.toString().padLeft(2, '0')}"),
                              controller.availableTimeList?[index]
                                          .isAvailable ==
                                      true
                                  ? const Text('Available')
                                  : const Text('Not Available')
                            ]),
                          )),
                )));
}

dynamic addressInfo() {
  Get.defaultDialog(
      cancel: ElevatedButton(
        style:
            const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
      title: 'Address Information',
      content: GetBuilder<AddresController>(
        init: AddresController(),
        builder: (controller) => controller.address == null
            ? CircularProgressIndicator(
                color: Get.theme.primaryColor,
              )
            : Column(
                children: [
                  ListTile(
                    title: Text(
                      'City',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(controller.address!.city),
                    leading: const Icon(Icons.location_city),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text(
                      'Governorate',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(controller.address!.governorate),
                    leading: const Icon(Icons.holiday_village),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text('Street',
                        style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(controller.address!.street),
                    leading: const Icon(Icons.edit_road),
                    iconColor: Get.theme.primaryColor,
                  ),
                ],
              ),
      ));
}

dynamic profileInfo() {
  Get.defaultDialog(
      cancel: ElevatedButton(
        style:
            const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
      title: 'Profile Information',
      content: GetBuilder<ProfileDoctorController>(
        init: ProfileDoctorController(),
        builder: (controller) => controller.doctor == null
            ? CircularProgressIndicator(
                color: Get.theme.primaryColor,
              )
            : Column(
                children: [
                  ListTile(
                    title: Text(
                      'Full Name',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Dr. ${controller.doctor!.firstName} ${controller.doctor!.lastName}'),
                    leading: const Icon(Icons.person),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(controller.doctor!.email),
                    leading: const Icon(Icons.email_outlined),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text('Phone Number',
                        style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(controller.doctor!.phoneNumber),
                    leading: const Icon(Icons.phone),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text('Specialization',
                        style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(controller.specialization!.name),
                    leading: const Icon(Icons.medical_services_outlined),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text(
                      'Gender',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: controller.doctor!.gender == true
                        ? const Text('Male')
                        : const Text('Female'),
                    leading: controller.doctor!.gender == true
                        ? const Icon(Icons.male)
                        : const Icon(Icons.female),
                    iconColor: Get.theme.primaryColor,
                  ),
                  ListTile(
                    title: Text(
                      'Age',
                      style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        controller.calculateAge(controller.doctor!.birthDate)),
                    leading: const Icon(Icons.date_range),
                    iconColor: Get.theme.primaryColor,
                  ),
                ],
              ),
      ));
}

dynamic editAddress() {
  Get.defaultDialog(
      cancel: ElevatedButton(
        style:
            const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
      confirm: GetBuilder<AddresController>(
        //init: AddresController(),
        builder: (controller) => ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Get.theme.primaryColor)),
          onPressed: () {
            var address = Address(
                id: sharedPreferences!.getInt('id'),
                //id: 9,
                city: controller.cityController.text,
                governorate: controller.governorateController.text,
                street: controller.streetController.text);
            controller.addAddress(address);
          },
          child: const Text('Save changes'),
        ),
      ),
      title: 'Edit Address',
      content: GetBuilder<AddresController>(
        init: AddresController(),
        builder: (controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: controller.cityController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Get.theme.primaryColor),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor)),
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: Get.theme.primaryColor,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Get.theme.primaryColor, width: 2)),
                    labelText: 'City',
                    labelStyle: TextStyle(
                      color: Get.theme.primaryColor,
                    ),
                    hintText: 'Enter your city'),
                style: TextStyle(color: Get.theme.primaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: controller.governorateController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Get.theme.primaryColor),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor)),
                    prefixIcon: Icon(
                      Icons.holiday_village,
                      color: Get.theme.primaryColor,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Get.theme.primaryColor, width: 2)),
                    labelText: 'Governorate',
                    labelStyle: TextStyle(
                      color: Get.theme.primaryColor,
                    ),
                    hintText: 'Enter your governorate'),
                style: TextStyle(color: Get.theme.primaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: controller.streetController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Get.theme.primaryColor),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor)),
                    prefixIcon: Icon(
                      Icons.edit_road,
                      color: Get.theme.primaryColor,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Get.theme.primaryColor, width: 2)),
                    labelText: 'Street',
                    labelStyle: TextStyle(
                      color: Get.theme.primaryColor,
                    ),
                    hintText: 'Enter your street'),
                style: TextStyle(color: Get.theme.primaryColor),
              ),
            ),
          ],
        ),
      ));
}

dynamic editDoctorInfo() {
  Get.defaultDialog(
      cancel: GetBuilder<ProfileDoctorController>(
        builder: (controller) => ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red)),
          onPressed: () {
            controller.unsaveImage();
            Get.back();
          },
          child: const Text('Cancel'),
        ),
      ),
      confirm: GetBuilder<ProfileDoctorController>(
        builder: (controller) => ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Get.theme.primaryColor)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              var doctor = DoctorProfile(
                  id: controller.doctor!.id,
                  image: controller.doctor?.image,
                  applicationUserId: controller.doctor!.applicationUserId,
                  firstName: controller.firstNameController.text,
                  lastName: controller.lastNameController.text,
                  email: controller.emailController.text,
                  phoneNumber: controller.phoneController.text,
                  specializationId: controller.doctor!.specializationId,
                  gender: controller.doctor!.gender,
                  birthDate: controller.doctor!.birthDate);

              controller.editDoctor(doctor);
            }
          },
          child: const Text('Save changes'),
        ),
      ),
      title: 'Edit ProfileInfo',
      content: GetBuilder<ProfileDoctorController>(
        init: ProfileDoctorController(),
        builder: (controller) => Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  maxLength: 20,
                  controller: controller.firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your user name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      counterText: '',
                      hintStyle: TextStyle(color: Get.theme.primaryColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Get.theme.primaryColor)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Get.theme.primaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor, width: 2)),
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      hintText: 'Enter your first name'),
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  maxLength: 20,
                  controller: controller.lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your user name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      counterText: '',
                      hintStyle: TextStyle(color: Get.theme.primaryColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Get.theme.primaryColor)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Get.theme.primaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor, width: 2)),
                      labelText: 'Last Name',
                      labelStyle: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      hintText: 'Enter your last name'),
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: controller.phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!isValidPhoneNumber(
                        controller.phoneController.text)) {
                      return 'Please enter a vaild syrain phone number (09........)';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      counterText: '',
                      hintStyle: TextStyle(color: Get.theme.primaryColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Get.theme.primaryColor)),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Get.theme.primaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor, width: 2)),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      hintText: 'Enter your phone number'),
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!isValidEmail(controller.emailController.text)) {
                      return 'Your Email is not vaild';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Get.theme.primaryColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Get.theme.primaryColor)),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Get.theme.primaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor, width: 2)),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      hintText: 'Enter valid mail id as abc@gmail.com'),
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: controller.doctor?.image == null
                            ? Image.asset(
                                'images/unknown.png',
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'images/${controller.doctor!.image}',
                                fit: BoxFit.cover,
                              ),
                      ),
                      IconButton(
                        onPressed: controller.pickAndMoveImage,
                        icon: const Icon(Icons.add_a_photo),
                        color: Get.theme.primaryColor,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ));
}

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

bool isValidPhoneNumber(String phoneNumber) {
  return RegExp(r'^0[0-9]{9}$').hasMatch(phoneNumber);
}
