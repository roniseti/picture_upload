// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoAdapter extends TypeAdapter<Photo> {
  @override
  final int typeId = 1;

  @override
  Photo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Photo(
      dbId: fields[0] as String,
      title: fields[1] as String,
      imageUrl: fields[2] as String?,
      thumbUrl: fields[3] as String?,
      imageLocal: fields[4] as String?,
      thumbLocal: fields[5] as String?,
      isUploaded: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Photo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.dbId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.thumbUrl)
      ..writeByte(4)
      ..write(obj.imageLocal)
      ..writeByte(5)
      ..write(obj.thumbLocal)
      ..writeByte(6)
      ..write(obj.isUploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    dbId: json['dbId'] as String,
    title: json['title'] as String,
    imageUrl: json['imageUrl'] as String?,
    thumbUrl: json['thumbUrl'] as String?,
    imageLocal: json['imageLocal'] as String?,
    thumbLocal: json['thumbLocal'] as String?,
    isUploaded: json['isUploaded'] as bool,
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'dbId': instance.dbId,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'thumbUrl': instance.thumbUrl,
      'imageLocal': instance.imageLocal,
      'thumbLocal': instance.thumbLocal,
      'isUploaded': instance.isUploaded,
    };
