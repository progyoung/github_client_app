import 'package:json_annotation/json_annotation.dart';

part 'repo.g.dart';

@JsonSerializable()
class Repo {
  Repo(this.id, this.full_name, this.forks_count, this.stargazers_count,
      this.open_issues_count, this.description);

  num id;
  String full_name;
  num forks_count;
  num stargazers_count;
  num open_issues_count;
  String description;

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);
}
