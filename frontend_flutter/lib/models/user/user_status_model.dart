// To parse this JSON data, do
//
//     final userStatusModel = userStatusModelFromMap(jsonString);

import 'dart:convert';

import 'package:whatsapp_clone/models/user/user_model.dart';

UserStatusModel userStatusModelFromMap(String str) =>
    UserStatusModel.fromMap(json.decode(str));

String userStatusModelToMap(UserStatusModel data) => json.encode(data.toMap());

class UserStatusModel {
  UserStatusModel({
    this.createdAt,
    this.userData,
  });

  DateTime? createdAt;
  UserModel? userData;

  factory UserStatusModel.fromMap(Map<String, dynamic> json) => UserStatusModel(
        createdAt: DateTime.parse(json["createdAt"]),
        userData: UserModel.fromMap(json["userData"]),
      );

  Map<String, dynamic> toMap() => {
        "createdAt": createdAt?.toIso8601String(),
        "userData": userData?.toMap(),
      };
}
