class ChatUsers {
  int chatId;
  String userFirstName;
  String userLastName;
  String userImage;
  bool userGender;
  String userLastMessage;

  // String name;
  // String messageText;
  // String imageURL;
  // String time;
  ChatUsers(
      {required this.chatId,
      required this.userFirstName,
      required this.userLastName,
      required this.userImage,
      required this.userGender,
      required this.userLastMessage});

  factory ChatUsers.fromJson(Map<String, dynamic> json) => ChatUsers(
      chatId: json["chatId"],
      userFirstName: json["userFirstName"],
      userLastName: json["userLastName"],
      userImage: json["userImage"],
      userGender: json["userGender"],
      userLastMessage: json["userLastMessage"]);

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "userFirstName": userFirstName,
        "userLastName": userLastName,
        "userImage": userImage,
        "userGender": userGender,
        "userLastMessage": userLastMessage
      };
}
