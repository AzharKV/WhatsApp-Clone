// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_chat_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DbChatListModelAdapter extends TypeAdapter<DbChatListModel> {
  @override
  final int typeId = 4;

  @override
  DbChatListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DbChatListModel(
      message: fields[0] as String,
      createdAt: fields[3] as DateTime,
      messageType: fields[5] as String?,
      filePath: fields[6] as String?,
      messageId: fields[1] as String,
      userId: fields[2] as String,
      unreadCount: fields[7] as int,
      tickCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DbChatListModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.messageId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.tickCount)
      ..writeByte(5)
      ..write(obj.messageType)
      ..writeByte(6)
      ..write(obj.filePath)
      ..writeByte(7)
      ..write(obj.unreadCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DbChatListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
