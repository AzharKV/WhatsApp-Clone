import 'package:hive_flutter/hive_flutter.dart';

part 'db_message_model.g.dart';

@HiveType(typeId: 2)
class DbMessageModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final String from;

  @HiveField(3)
  final String to;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  DateTime? receivedAt;

  @HiveField(6)
  DateTime? openedAt;

  @HiveField(7)
  final String? messageType;

  @HiveField(8)
  final String? filePath;

  DbMessageModel({
    required this.id,
    required this.message,
    required this.from,
    required this.to,
    required this.createdAt,
    this.receivedAt,
    this.openedAt,
    this.messageType,
    this.filePath,
  });
}
