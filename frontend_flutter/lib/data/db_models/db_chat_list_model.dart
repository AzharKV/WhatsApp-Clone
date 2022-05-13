import 'package:hive_flutter/hive_flutter.dart';

part 'db_chat_list_model.g.dart';

@HiveType(typeId: 4)
class DbChatListModel {
  @HiveField(0)
  final String message;

  @HiveField(1)
  final String messageId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  int tickCount;

  @HiveField(5)
  final String? messageType;

  @HiveField(6)
  final String? filePath;

  @HiveField(7)
  int unreadCount;

  @HiveField(8)
  String profileImage;

  DbChatListModel({
    required this.message,
    required this.createdAt,
    this.messageType,
    this.filePath,
    required this.messageId,
    required this.userId,
    required this.unreadCount,
    this.tickCount = 0,
    this.profileImage = "",
  });
}
