// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_pending_message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DbPendingMessageModelAdapter extends TypeAdapter<DbPendingMessageModel> {
  @override
  final int typeId = 3;

  @override
  DbPendingMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DbPendingMessageModel(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DbPendingMessageModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.messageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DbPendingMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
