// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.image,
    this.about,
    this.lastSeen,
    this.status,
    this.sockedId,
    this.phoneNumber,
    this.phoneWithDialCode,
    this.dialCode,
    this.createdAt,
  });

  String? id;
  String? name;
  String? image;
  String? about;
  DateTime? lastSeen;
  bool? status;
  String? sockedId;
  String? phoneNumber;
  String? phoneWithDialCode;
  String? dialCode;
  DateTime? createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        about: json["about"] == null ? null : json["about"],
        lastSeen:
            json["lastSeen"] == null ? null : DateTime.parse(json["lastSeen"]),
        status: json["status"] == null ? null : json["status"],
        sockedId: json["sockedId"] == null ? null : json["sockedId"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        phoneWithDialCode: json["phoneWithDialCode"] == null
            ? null
            : json["phoneWithDialCode"],
        dialCode: json["dialCode"] == null ? null : json["dialCode"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
        "about": about == null ? null : about,
        "lastSeen": lastSeen == null ? null : lastSeen!.toIso8601String(),
        "status": status == null ? null : status,
        "sockedId": sockedId == null ? null : sockedId,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "phoneWithDialCode":
            phoneWithDialCode == null ? null : phoneWithDialCode,
        "dialCode": dialCode == null ? null : dialCode,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}
