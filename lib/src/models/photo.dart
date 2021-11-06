import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  Photo({
    required this.title,
    this.imageUrl,
    this.thumbUrl,
    this.imageLocal,
    this.thumbLocal,
    this.isUploaded = true
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  String title;
  String? imageUrl;
  String? thumbUrl;
  String? imageLocal;
  String? thumbLocal;
  bool isUploaded;

}