// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DbUserModelAdapter extends TypeAdapter<DbUserModel> {
  @override
  final int typeId = 1;

  @override
  DbUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DbUserModel(
      name: fields[1] as String,
      id: fields[0] as String,
      imagePath: fields[2] as String,
      phone: fields[3] as String,
      about: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DbUserModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.about);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DbUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
