// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      comment: json['comment'] as String,
      owner: json['owner'] as String,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'comment': instance.comment,
      'owner': instance.owner,
    };
