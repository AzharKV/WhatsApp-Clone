// To parse this JSON data, do
//
//     final usersListModel = usersListModelFromMap(jsonString);

import 'dart:convert';

import 'package:whatsapp_clone/data/model/user/user_model.dart';

UsersListModel usersListModelFromMap(String str) =>
    UsersListModel.fromMap(json.decode(str));

String usersListModelToMap(UsersListModel data) => json.encode(data.toMap());

class UsersListModel {
  UsersListModel({
    this.createdAt,
    this.users,
  });

  DateTime? createdAt;
  List<UserModel>? users;

  factory UsersListModel.fromMap(Map<String, dynamic> json) => UsersListModel(
        createdAt: DateTime.parse(json["createdAt"]),
        users: List<UserModel>.from(
            json["users"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        "createdAt": createdAt?.toIso8601String(),
        "users": List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}
