// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String,
      garden_name: json['garden_name'] as String?,
      email: json['email'] as String,
      description: json['description'] as String,
      image_url: json['image_url'] as String,
      respects: json['respects'] as int,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'garden_name': instance.garden_name,
      'email': instance.email,
      'description': instance.description,
      'image_url': instance.image_url,
      'respects': instance.respects,
    };
