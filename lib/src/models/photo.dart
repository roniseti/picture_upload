import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
@HiveType(typeId : 1)
class Photo {
  Photo({
    required this.dbId,
    required this.title,
    this.imageUrl,
    this.thumbUrl,
    this.imageLocal,
    this.thumbLocal,
    this.isUploaded = true
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  /// UUID for hive key
  @HiveField(0)
  String dbId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? imageUrl;

  @HiveField(3)
  String? thumbUrl;

  @HiveField(4)
  String? imageLocal;

  @HiveField(5)
  String? thumbLocal;

  /// Indicate photo is uploaded or not yet. if uploaded then local file will removed
  @HiveField(6)
  bool isUploaded;

}