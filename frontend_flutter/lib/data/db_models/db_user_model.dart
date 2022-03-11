import 'package:hive_flutter/hive_flutter.dart';

part 'db_user_model.g.dart';

@HiveType(typeId: 1)
class DbUserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String about;

  DbUserModel({
    required this.name,
    required this.id,
    required this.imagePath,
    required this.phone,
    required this.about,
  });
}
