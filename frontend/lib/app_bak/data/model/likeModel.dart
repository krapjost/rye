import 'package:json_annotation/json_annotation.dart';

part 'likeModel.g.dart';

@JsonSerializable()
class LikeModel {
  final String feed_id;
  final String user_id;

  const LikeModel({
    required this.feed_id,
    required this.user_id,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) =>
      _$LikeModelFromJson(json);

  Map<String, dynamic> toJson() => _$LikeModelToJson(this);
}
