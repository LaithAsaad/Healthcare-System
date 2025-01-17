class Specialization {
  Specialization({
    required this.id,
    required this.name,
    required this.image,
  });

  int id;
  String name;
  String image;

  //Specialization.init();

  factory Specialization.fromJson(Map<String, dynamic> json) => Specialization(
        id: json["id"],
        name: json["name"],
        image: json["image"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image
      };
}
