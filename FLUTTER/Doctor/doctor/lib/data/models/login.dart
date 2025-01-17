class LogInModel{
  LogInModel({
    required this.email,
    required this.password,

  });

  String email;
  String password;

 factory LogInModel.fromJson(Map<String, dynamic> json) => LogInModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}