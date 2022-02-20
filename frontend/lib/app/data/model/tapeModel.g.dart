// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tapeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TapeModel _$TapeModelFromJson(Map<String, dynamic> json) => TapeModel(
      tag: json['tag'] as String,
      created_at: json['created_at'] as String,
      owner: json['owner'] as String,
    );

Map<String, dynamic> _$TapeModelToJson(TapeModel instance) => <String, dynamic>{
      'tag': instance.tag,
      'created_at': instance.created_at,
      'owner': instance.owner,
    };
