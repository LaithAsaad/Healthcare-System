class Patient {
  Patient({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.birthDate,
  });
  int? id;
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPassword;
  String phoneNumber;
  DateTime birthDate;

  //Patient.init();

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
        phoneNumber: json["phoneNumber"],
        birthDate: DateTime.parse(json["birthDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "phoneNumber": phoneNumber,
        "birthDate": birthDate.toIso8601String(),
      };
}
