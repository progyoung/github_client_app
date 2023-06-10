// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) => Repo(
      json['id'] as num,
      json['full_name'] as String,
      json['forks_count'] as num,
      json['stargazers_count'] as num,
      json['open_issues_count'] as num,
      json['description'] as String,
    );

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'id': instance.id,
      'full_name': instance.full_name,
      'forks_count': instance.forks_count,
      'stargazers_count': instance.stargazers_count,
      'open_issues_count': instance.open_issues_count,
      'description': instance.description,
    };
