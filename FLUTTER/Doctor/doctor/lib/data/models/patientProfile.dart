class PatientProfile {
  final int id;
  final String applicationUserId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  DateTime birthDate;

  PatientProfile({
    required this.id,
    required this.applicationUserId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    final applicationUser = json["applicationUser"];
    return PatientProfile(
      id: json["id"],
      applicationUserId: json["applicationUserId"],
      firstName: json["firstName"],
      lastName:json["lastName"],
      email: applicationUser["email"],
      phoneNumber: applicationUser["phoneNumber"],
      birthDate: DateTime.parse(json["birthDate"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "applicationUserId":applicationUserId,
        "firstName": firstName,
        "lastName":lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "birthDate":birthDate.toIso8601String(),
      };
}
