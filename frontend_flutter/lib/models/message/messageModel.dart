// To parse this JSON data, do
//
//     final messageModel = messageModelFromMap(jsonString);

import 'dart:convert';

MessageModel messageModelFromMap(String str) =>
    MessageModel.fromMap(json.decode(str));

String messageModelToMap(MessageModel data) => json.encode(data.toMap());

class MessageModel {
  MessageModel({
    this.message,
    this.from,
    this.to,
    this.date,
  });

  String? message;
  String? from;
  String? to;
  DateTime? date;

  factory MessageModel.fromMap(Map<String, dynamic> json) => MessageModel(
        message: json["message"] == null ? null : json["message"],
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message == null ? null : message,
        "from": from == null ? null : from,
        "to": to == null ? null : to,
        "date": date == null ? null : date!.toIso8601String(),
      };
}
