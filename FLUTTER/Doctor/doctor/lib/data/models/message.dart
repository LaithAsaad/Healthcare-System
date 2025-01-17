class Message {
  Message({
    this.id,
    this.chatId,
    required this.messageContent,
    required this.date,
    required this.byPatient,
    required this.isEdited,
    required this.isRead,
  });
  int? id;
  int? chatId;
  String messageContent;
  DateTime date;
  bool byPatient;
  bool? isEdited;
  bool? isRead;
  factory Message.fromJson(Map<String, dynamic> json) => Message(
      id: json["id"],
      chatId: json["chatId"],
      messageContent: json["messageContent"],
      date: DateTime.parse(json["date"]),
      byPatient: json["byPatient"],
      isEdited: json["isEdited"],
      isRead: json["isRead"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatId": chatId,
        "messageContent": messageContent,
        "date": date.toIso8601String(),
        "byPatient": byPatient,
        "isEdited": isEdited,
        "isRead": isRead,
      };

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is Message && other.id == id && other.chat_id == chat_id;
  //   // Add other properties you want to compare...
  // }

  // @override
  // int get hashCode => id.hashCode ^ chat_id.hashCode; // ^ other properties...
}
