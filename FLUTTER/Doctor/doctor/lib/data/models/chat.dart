class Chat {
  Chat({
    required this.id,
    required this.patientId,
    this.doctorId,
  });
  int id;
  int patientId;
  int? doctorId;
  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
      id: json["id"], patientId: json["patientId"], doctorId: json["doctorId"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "patientId": patientId, "doctorId": doctorId};

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is Chat && other.id == id && other.patientId == patientId;
  //   // Add other properties you want to compare...
  // }

  // @override
  // int get hashCode =>
  //     id.hashCode ^ patientId.hashCode; // ^ other properties...
}
