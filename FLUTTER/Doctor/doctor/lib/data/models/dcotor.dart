class Doctor {
  Doctor({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.specializationId,
    required this.gender,
    required this.birthDate
  });
  int? id;
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPassword;
  String phoneNumber;
  int specializationId;
  bool gender;
  DateTime birthDate;

  //Doctor.init();

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
        phoneNumber: json["phoneNumber"],
        specializationId: json["specializationId"],
        gender: json["gender"],
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
        "specializationId":specializationId,
        "gender": gender,
        "birthDate":birthDate.toIso8601String(),
      };
}
