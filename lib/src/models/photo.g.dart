// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    title: json['title'] as String,
    imageUrl: json['imageUrl'] as String?,
    thumbUrl: json['thumbUrl'] as String?,
    imageLocal: json['imageLocal'] as String?,
    thumbLocal: json['thumbLocal'] as String?,
    isUploaded: json['isUploaded'] as bool,
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'thumbUrl': instance.thumbUrl,
      'imageLocal': instance.imageLocal,
      'thumbLocal': instance.thumbLocal,
      'isUploaded': instance.isUploaded,
    };
