import 'package:json_annotation/json_annotation.dart';

part 'commentModel.g.dart';

@JsonSerializable()
class CommentModel {
  final String uid;
  final String name;
  final String comment;
  final String owner;

  const CommentModel({
    required this.uid,
    required this.name,
    required this.comment,
    required this.owner,
  });
  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
