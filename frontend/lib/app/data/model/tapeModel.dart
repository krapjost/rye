import 'package:json_annotation/json_annotation.dart';

part 'tapeModel.g.dart';

@JsonSerializable()
class TapeModel {
  final String tag;
  final String created_at;
  final String owner;

  const TapeModel({
    required this.tag,
    required this.created_at,
    required this.owner,
  });

  factory TapeModel.fromJson(Map<String, dynamic> json) =>
      _$TapeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TapeModelToJson(this);
}
