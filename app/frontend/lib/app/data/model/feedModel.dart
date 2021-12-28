import 'package:json_annotation/json_annotation.dart';
import 'commentModel.dart';

part 'feedModel.g.dart';

@JsonSerializable()
class FeedModel {
  final String url;
  final String description;
  final DateTime created_at;
  final String owner;
  final int likes;
  final List<CommentModel>? comments;

  const FeedModel(
      {required this.url,
      required this.description,
      required this.created_at,
      required this.likes,
      required this.owner,
      this.comments});

  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedModelToJson(this);
}
