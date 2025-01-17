class AvailableTime {
  AvailableTime({
    this.id,
    required this.doctorId,
    required this.dayId,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.reasonOfUnavilability
  });

  int? id;
  int doctorId;
  int dayId;
  DateTime startTime;
  DateTime endTime;
  bool isAvailable;
  String? reasonOfUnavilability;

  //AvailableTime.init();

  factory AvailableTime.fromJson(Map<String, dynamic> json) => AvailableTime(
        id: json["id"],
        doctorId: json["doctorId"],
        dayId: json["dayId"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        isAvailable: json["isAvailable"],
        reasonOfUnavilability: json["reasonOfUnavilability"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "isAvailable": isAvailable,
        "doctorId":doctorId,
        "dayId":dayId,
        "reasonOfUnavilability":reasonOfUnavilability
      };
}
