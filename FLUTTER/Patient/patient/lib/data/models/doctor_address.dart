class DoctorAddress {
  final int id;
  final String firstName;
  final String lastName;
  String? image;
  final int specializationId;
  final bool gender;
  DateTime birthDate;
  String city;
  String governorate;
  String street;

  DoctorAddress({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.specializationId,
    required this.gender,
    required this.birthDate,
    required this.city,
    required this.governorate,
    required this.street,
  });

  factory DoctorAddress.fromJson(Map<String, dynamic> json) {
    final address = json["address"];
    return DoctorAddress(
      id: json["id"],
      image: json["image"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      specializationId: json["specializationId"],
      gender: json["gender"],
      birthDate: DateTime.parse(json["birthDate"]),
      city: address["city"],
      governorate: address["governorate"],
      street: address["street"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
        "specializationId": specializationId,
        "gender": gender,
        "birthDate": birthDate.toIso8601String(),
        "city": city,
        "governorate": governorate,
        "street": street,
      };

  static String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }
}
