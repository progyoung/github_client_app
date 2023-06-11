import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/repo.dart';
import '../app_state.dart';

// todo stateful widget maybe?
class RepoItem extends StatelessWidget {
  const RepoItem({super.key, required this.repo});

  final Repo repo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(repo.owner.avatar_url),
            ),
            Text(repo.name),
            Text(repo.language),
          ],
        ),
        Text(repo.full_name),
        Text(repo.description),
        Row(
          children: [
            Text("start: "),
            Text(repo.stargazers_count as String),
            Text("issues: "),
            Text(repo.open_issues_count as String),
          ],
        ),
      ],
    );
  }
}

class RepoList extends StatefulWidget {
  const RepoList({super.key});

  @override
  State<RepoList> createState() => _RepoListState();
}

class _RepoListState extends State<RepoList> {
  late Future<Repo> repos;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void initState() {
    repos = fetchRepos();
    super.initState();
  }

  Future<Repo> fetchRepos() async {
    var headers = {
      "Authorization": "Bearer token",
      "X-GitHub-Api-Version": "2022-11-28",
    };
    final response = await http
        .get(Uri.parse("https://api.github.com/user/repos"), headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Repo.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
