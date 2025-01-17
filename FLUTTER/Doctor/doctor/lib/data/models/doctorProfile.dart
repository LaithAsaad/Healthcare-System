class DoctorProfile {
  final int id;
  final String applicationUserId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  String? image;
  final int specializationId;
  final bool gender;
  DateTime birthDate;

  DoctorProfile({
    required this.id,
    required this.applicationUserId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.image,
    required this.specializationId,
    required this.gender,
    required this.birthDate,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    final applicationUser = json["applicationUser"];
    return DoctorProfile(
      id: json["id"],
      applicationUserId: json["applicationUserId"],
      image: json["image"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: applicationUser["email"],
      phoneNumber: applicationUser["phoneNumber"],
      specializationId: json["specializationId"],
      gender: json["gender"],
      birthDate: DateTime.parse(json["birthDate"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "applicationUserId":applicationUserId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "image":image,
        "specializationId": specializationId,
        "gender": gender,
        "birthDate":birthDate.toIso8601String(),
      };
}
