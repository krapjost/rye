// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) => FeedModel(
      url: json['url'] as String,
      description: json['description'] as String,
      created_at: DateTime.parse(json['created_at'] as String),
      likes: json['likes'] as int,
      owner: json['owner'] as String,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedModelToJson(FeedModel instance) => <String, dynamic>{
      'url': instance.url,
      'description': instance.description,
      'created_at': instance.created_at.toIso8601String(),
      'owner': instance.owner,
      'likes': instance.likes,
      'comments': instance.comments,
    };
