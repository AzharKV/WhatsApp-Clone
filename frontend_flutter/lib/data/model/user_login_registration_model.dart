// To parse this JSON data, do
//
//     final userLoginRegistrationModel = userLoginRegistrationModelFromJson(jsonString);

import 'dart:convert';

import 'package:whatsapp_clone/data/model/user/user_model.dart';

UserLoginRegistrationModel userLoginRegistrationModelFromJson(String str) =>
    UserLoginRegistrationModel.fromJson(json.decode(str));

String userLoginRegistrationModelToJson(UserLoginRegistrationModel data) =>
    json.encode(data.toJson());

class UserLoginRegistrationModel {
  UserLoginRegistrationModel({
    this.message,
    this.token,
    this.user,
    this.createdAt,
  });

  String? message;
  String? token;
  UserModel? user;
  DateTime? createdAt;

  factory UserLoginRegistrationModel.fromJson(Map<String, dynamic> json) =>
      UserLoginRegistrationModel(
        message: json["message"] == null ? null : json["message"],
        token: json["token"] == null ? null : json["token"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "token": token == null ? null : token,
        "user": user == null ? null : user!.toJson(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}
