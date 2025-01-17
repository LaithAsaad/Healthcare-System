import 'package:flutter/material.dart';
import 'package:doctor/controller/bookingMangerController.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingManager extends StatelessWidget {
  const BookingManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GetBuilder<BookingManagerController>(
          init: BookingManagerController(),
          builder: (controller) => FloatingActionButton(
            onPressed: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );
              if (pickedTime != null) {
                controller.addEvent(controller.selectedDay, pickedTime);
              }
            },
            backgroundColor: Get.theme.primaryColor,
            child: const Icon(Icons.add_alarm_outlined),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          title: const Text(
            "Calendar",
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 0, 0, 0),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: GetBuilder<BookingManagerController>(
                  init: BookingManagerController(),
                  builder: (controller) => Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                              "Selected Day ${controller.focusedDay.toString().split(" ")[0]}")),
                      TableCalendar(
                        //onHeaderTapped: _selectedDay,
                        calendarFormat: CalendarFormat.twoWeeks,
                        selectedDayPredicate: (day) {
                          return isSameDay(controller.focusedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          controller.onDaySelected(selectedDay, focusedDay);
                        },

                        rangeStartDay: controller.today,
                        rangeEndDay:
                            DateTime.now().add(const Duration(days: 6)),
                        firstDay: controller.today,
                        lastDay: DateTime.now().add(const Duration(days: 6)),
                        focusedDay: controller.focusedDay,
                        headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronVisible: false,
                            rightChevronVisible: false),
                        availableGestures: AvailableGestures.none,
                        calendarBuilders: CalendarBuilders(
                          rangeHighlightBuilder:
                              (context, day, isWithinRange) => Container(
                            margin: const EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle),
                            child: Text(
                              day.day.toString(),
                            ),
                          ),
                          rangeStartBuilder: (context, day, focusedDay) =>Container(),
                          rangeEndBuilder: (context, day, focusedDay) =>Container(),
                          selectedBuilder: (context, day, focusedDay) =>
                              Container(
                            margin: const EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                shape: BoxShape.circle),
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          todayBuilder: (context, day, focusedDay) => Container(
                            margin: const EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5)),
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        eventLoader: controller.listOfDayEvents,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    const Text(
                      "The date of the consultation",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Booked'),
                        const Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 15,
                        ),
                        SizedBox(
                          width: Get.mediaQuery.size.width / 5,
                        ),
                        const Text('Available'),
                        Icon(
                          Icons.circle,
                          color: Get.theme.primaryColor,
                          size: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              GetBuilder<BookingManagerController>(
                init: BookingManagerController(),
                builder: (controller) => Expanded(
                  child: GridView.builder(
                    itemBuilder: (context, index) => InkWell(
                      splashColor: Colors.transparent,
                      onLongPress: () => showDialog(
                          context: context,
                          builder: (b) => AlertDialog(
                                title: const Text('Remove appointment'),
                                content: const Text(
                                    'Do you want to delete this appointment?'),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Get.theme.primaryColor)),
                                      onPressed: () => Get.back(),
                                      child: const Text('Cancel')),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () {
                                        controller.deletebooking(index);
                                        Get.back();
                                      },
                                      child: const Text('Delete'))
                                ],
                              )),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: controller
                                        .listOfDayEvents(
                                            controller.selectedDay)[index]
                                        .patientId ==
                                    null
                                ? Get.theme.primaryColor
                                : Colors.red),
                        alignment: Alignment.center,
                        child: Text(
                          '${controller.listOfDayEvents(controller.selectedDay)[index].bookingDate.hour.toString().padLeft(2, '0')}:${controller.listOfDayEvents(controller.selectedDay)[index].bookingDate.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    itemCount: controller
                        .listOfDayEvents(controller.selectedDay)
                        .length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3 / 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
