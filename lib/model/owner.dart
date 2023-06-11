import 'package:json_annotation/json_annotation.dart';
part 'owner.g.dart';

@JsonSerializable()
class Owner {
  Owner();

  late String avatar_url;
  late String login;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
