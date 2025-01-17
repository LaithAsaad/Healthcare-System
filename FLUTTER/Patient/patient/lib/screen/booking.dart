import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controller/makeBookingController.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          controller.changeIndex(null);
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
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          todayBuilder: (context, today, focusedDay) =>
                              Container(
                            margin: const EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.theme.primaryColor.withOpacity(0.5)),
                            child: Text(
                              today.day.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        // calendarStyle: CalendarStyle(selectedTextStyle: TextStyle(color: Colors.amber)),
                        // eventLoader: (day) {
                        //   return _getEventsForDay(day);
                        // },
                        eventLoader: controller.listOfDayEvents,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: const Text("Select the date of the consultation"),
              ),
              GetBuilder<BookingManagerController>(
                init: BookingManagerController(),
                builder: (controller) => Expanded(
                  child: GridView.builder(
                    itemBuilder: (context, index) => InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        controller.changeIndex(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.currentIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: controller.currentIndex == index
                              ? Get.theme.primaryColor
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${controller.listOfDayEvents(controller.selectedDay)[index].bookingDate.hour.toString().padLeft(2, '0')}:${controller.listOfDayEvents(controller.selectedDay)[index].bookingDate.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: controller.currentIndex == index
                                ? Colors.white
                                : null,
                          ),
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
              GetBuilder<BookingManagerController>(
                init: BookingManagerController(),
                builder: (controller) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 60),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Get.theme.primaryColor)),
                        child: const Text('Make Appointment'),
                        onPressed: () async {
                          controller.bookingByPatient();
                        })),
              ),
            ],
          ),
        ));
  }
}
