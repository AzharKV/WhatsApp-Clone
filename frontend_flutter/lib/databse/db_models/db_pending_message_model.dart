import 'package:hive_flutter/hive_flutter.dart';

part 'db_pending_message_model.g.dart';

@HiveType(typeId: 3)
class DbPendingMessageModel {
  @HiveField(0)
  final String messageId;

  DbPendingMessageModel(this.messageId);
}
