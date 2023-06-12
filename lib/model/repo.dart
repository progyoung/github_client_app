import 'package:github_client_app/model/owner.dart';
import 'package:json_annotation/json_annotation.dart';

part 'repo.g.dart';

@JsonSerializable()
class Repo {
  Repo();

  late Owner owner;
  late num id;
  late String name;
  late String full_name;
  late num stargazers_count;
  late num open_issues_count;
  late String? description;
  late String? language;

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);
}
