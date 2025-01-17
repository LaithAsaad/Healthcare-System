class Address {
  Address({
    this.id,
    required this.city,
    required this.governorate,
    required this.street,
  });

  int? id;
  String city;
  String governorate;
  String street;

  //Address.init();

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        city: json["city"],
        governorate: json["governorate"],
        street: json["street"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "governorate": governorate,
        "street": street,
      };
}
