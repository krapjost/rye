import 'package:json_annotation/json_annotation.dart';

part 'respectModel.g.dart';

@JsonSerializable()
class RespectModel {
  final String followee_id;
  final String follower_id;

  const RespectModel({
    required this.followee_id,
    required this.follower_id,
  });

  factory RespectModel.fromJson(Map<String, dynamic> json) =>
      _$RespectModelFromJson(json);

  Map<String, dynamic> toJson() => _$RespectModelToJson(this);
}
