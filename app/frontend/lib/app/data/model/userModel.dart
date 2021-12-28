import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

@JsonSerializable()
class UserModel {
  final String name;
  final String? garden_name;
  final String email;
  final String description;
  final String image_url;
  final int respects;

  const UserModel({
    required this.name,
    this.garden_name,
    required this.email,
    required this.description,
    required this.image_url,
    required this.respects,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

class ProfileModel extends UserModel {
  final int total_tapes;
  final int total_feeds;
  ProfileModel(
    name,
    garden_name,
    email,
    description,
    image_url,
    respects, {
    required this.total_tapes,
    required this.total_feeds,
  }) : super(
            name: name,
            garden_name: garden_name,
            email: email,
            description: description,
            image_url: image_url,
            respects: respects);
}
