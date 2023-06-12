// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) => Repo()
  ..owner = Owner.fromJson(json['owner'] as Map<String, dynamic>)
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..full_name = json['full_name'] as String
  ..stargazers_count = json['stargazers_count'] as num
  ..open_issues_count = json['open_issues_count'] as num
  ..description = json['description'] as String?
  ..language = json['language'] as String?;

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'owner': instance.owner,
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.full_name,
      'stargazers_count': instance.stargazers_count,
      'open_issues_count': instance.open_issues_count,
      'description': instance.description,
      'language': instance.language,
    };
