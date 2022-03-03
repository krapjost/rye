// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) => FeedModel(
      owner: json['owner'] as String,
      video_url: json['video_url'] as String,
      thumbnail_url: json['thumbnail_url'] as String,
      description: json['description'] as String,
      created_at: DateTime.parse(json['created_at'] as String),
      likes: json['likes'] as int,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedModelToJson(FeedModel instance) => <String, dynamic>{
      'owner': instance.owner,
      'video_url': instance.video_url,
      'thumbnail_url': instance.thumbnail_url,
      'description': instance.description,
      'created_at': instance.created_at.toIso8601String(),
      'likes': instance.likes,
      'comments': instance.comments,
    };
