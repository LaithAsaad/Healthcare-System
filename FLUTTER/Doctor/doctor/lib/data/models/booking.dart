class Booking {
  Booking({
    this.id,
    required this.doctorId,
    this.patientId,
    required this.bookingDate,
  });

  int? id;
  int doctorId;
  int? patientId;
  DateTime bookingDate;


  //Booking.init();

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        doctorId: json["doctorId"],
        patientId: json["patientId"],
        bookingDate: DateTime.parse(json["bookingDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookingDate": bookingDate.toIso8601String(),
        "doctorId":doctorId,
        "patientId":patientId,
      };
}
