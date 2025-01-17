class DoctorBooking {
  DoctorBooking({
    this.id,
    required this.doctorId,
    this.patientId,
    required this.bookingDate,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.specializationId,
    required this.gender,
    required this.birthDate,
  });

  int? id;
  int doctorId;
  int? patientId;
  DateTime bookingDate;
  final String firstName;
  final String lastName;
  String? image;
  final int specializationId;
  final bool gender;
  DateTime birthDate;

  //DoctorBooking.init();

  factory DoctorBooking.fromJson(Map<String, dynamic> json) {
    final doctor = json["doctor"];
    return DoctorBooking(
      id: json["id"],
      doctorId: json["doctorId"],
      patientId: json["patientId"],
      bookingDate: DateTime.parse(json["bookingDate"]),
      image: doctor["image"],
      firstName: doctor["firstName"],
      lastName: doctor["lastName"],
      specializationId: doctor["specializationId"],
      gender: doctor["gender"],
      birthDate: DateTime.parse(doctor["birthDate"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookingDate": bookingDate.toIso8601String(),
        "doctorId": doctorId,
        "patientId": patientId,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
        "specializationId": specializationId,
        "gender": gender,
        "birthDate": birthDate.toIso8601String(),
      };
}
