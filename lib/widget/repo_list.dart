import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../model/repo.dart';
import '../app_state.dart';

// todo stateful widget maybe?
class RepoItem extends StatelessWidget {
  const RepoItem({super.key, required this.repo});

  final Repo repo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.blue[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(repo.owner.avatar_url),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      repo.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text(repo.language ?? ""),
              ],
            ),
            Text(repo.full_name),
            Text(
              repo.description ?? "",
              textAlign: TextAlign.left,
            ),
            Row(
              children: [
                const Icon(Icons.star_outline),
                Text(repo.stargazers_count.toString()),
                const SizedBox(width: 8.0),
                const Icon(Icons.adb_rounded),
                Text(repo.open_issues_count.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RepoList extends StatefulWidget {
  const RepoList({super.key});

  @override
  State<RepoList> createState() => _RepoListState();
}

class _RepoListState extends State<RepoList> {
  late Future<List<Repo>> repos;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Repo>>(
      future: repos,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error happens");
        } else if (snapshot.hasData) {
          return ListView(
            children: [for (var repo in snapshot.data!) RepoItem(repo: repo)],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  void initState() {
    repos = fetchRepos();
    super.initState();
  }

  Future<List<Repo>> fetchRepos() async {
    var appState = context.read<AppState>();
    if (!appState.isLogined) {
      throw Exception("Please login first");
    }
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${appState.token}",
      "X-GitHub-Api-Version": "2022-11-28",
    };
    final response = await http
        .get(Uri.parse("https://api.github.com/user/repos"), headers: headers);

    if (response.statusCode == 200) {
      var list = (jsonDecode(response.body) as List)
          .map((e) => Repo.fromJson(e))
          .toList();
      return list;
    } else {
      throw Exception('Failed to load repos');
    }
  }
}
