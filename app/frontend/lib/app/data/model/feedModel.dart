import 'package:json_annotation/json_annotation.dart';
import 'commentModel.dart';

part 'feedModel.g.dart';

@JsonSerializable()
class FeedModel {
  final String owner;
  final String video_url;
  final String thumbnail_url;
  final String description;
  final DateTime created_at;
  final int likes;
  final List<CommentModel>? comments;

  const FeedModel(
      {
      required this.owner,
      required this.video_url,
      required this.thumbnail_url,
      required this.description,
      required this.created_at,
      required this.likes,
      this.comments});

  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedModelToJson(this);
}
