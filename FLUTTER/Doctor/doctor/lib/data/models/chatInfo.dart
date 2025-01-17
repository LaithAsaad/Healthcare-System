class ChatInfo {
  int? chatId;
  int chatUserId;
  String userFirstName;
  String userLastName;
  String? userImage;
  bool userGender;
  String? userLastMessage;
  DateTime? lastMessageDate;
  int? numberOfUnreadMessage;

  ChatInfo(
      { this.chatId,
      required this.chatUserId,
      required this.userFirstName,
      required this.userLastName,
      this.userImage,
      required this.userGender,
      this.userLastMessage,
      this.lastMessageDate,
      this.numberOfUnreadMessage});

  factory ChatInfo.fromJson(Map<String, dynamic> json) => ChatInfo(
      chatId: json["chatId"],
      userFirstName: json["userFirstName"],
      userLastName: json["userLastName"],
      userImage: json["userImage"],
      userGender: json["userGender"],
      userLastMessage: json["userLastMessage"],
      lastMessageDate: DateTime.parse(json["lastMessageDate"]),
      numberOfUnreadMessage: json["numberOfUnreadMessage"],
      chatUserId: json["chatUserId"]);

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "userFirstName": userFirstName,
        "userLastName": userLastName,
        "userImage": userImage,
        "userGender": userGender,
        "userLastMessage": userLastMessage,
        "lastMessageDate": lastMessageDate?.toIso8601String(),
        "numberOfUnreadMessage": numberOfUnreadMessage,
        "chatUserId": chatUserId
      };
}
