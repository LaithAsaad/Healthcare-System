class ChatUsers {
  int patientId;
  String userFirstName;
  String userLastName;
  String userImage;
  bool userGender;
  String userLastMessage;
  int messageId;

  // String name;
  // String messageText;
  // String imageURL;
  // String time;
  ChatUsers(
      {required this.patientId,
      required this.userFirstName,
      required this.userLastName,
      required this.userImage,
      required this.userGender,
      required this.userLastMessage,
      required this.messageId});

  factory ChatUsers.fromJson(Map<String, dynamic> json) => ChatUsers(
      patientId: json["patientId"],
      userFirstName: json["userFirstName"],
      userLastName: json["userLastName"],
      userImage: json["userImage"],
      userGender: json["userGender"],
      userLastMessage: json["userLastMessage"],
      messageId: json["messageId"]);

  Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "userFirstName": userFirstName,
        "userLastName": userLastName,
        "userImage": userImage,
        "userGender": userGender,
        "userLastMessage": userLastMessage,
        "messageId": messageId
      };
}
