// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.phone,
    this.imageUrl,
    this.about,
    this.lastSeen,
    this.status,
    this.socketId,
  });

  String? id;
  String? name;
  String? phone;
  String? imageUrl;
  String? about;
  DateTime? lastSeen;
  bool? status;
  String? socketId;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        name: json["name"],
        phone: json["phone"],
        imageUrl: json["imageUrl"],
        about: json["about"],
        lastSeen: DateTime.parse(json["lastSeen"] ?? DateTime.now().toString()),
        status: json["status"],
        socketId: json["socketId"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "phone": phone,
        "imageUrl": imageUrl,
        "about": about,
        "lastSeen": lastSeen?.toIso8601String(),
        "status": status,
        "socketId": socketId,
      };
}
