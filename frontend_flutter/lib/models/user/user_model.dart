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
    this.imageUrl,
    this.phone,
    this.about,
    this.createdAt,
  });

  String? id;
  String? name;
  String? imageUrl;
  String? phone;
  String? about;
  DateTime? createdAt;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
        phone: json["phone"] == null ? null : json["phone"],
        about: json["about"] == null ? null : json["about"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "imageUrl": imageUrl == null ? null : imageUrl,
        "phone": phone == null ? null : phone,
        "about": about == null ? null : about,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}
