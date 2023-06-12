import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'app_state.dart';
import 'widget/repo_list.dart';

void main(List<String> args) {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: const GithubClientApp(),
  ));
}

class GithubClientApp extends StatelessWidget {
  const GithubClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: appState.themeColor)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Github Client App'),
      ),
      drawer: const HomeDraw(),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var notLogindShow = Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        child: const Text("login"),
      ),
    );
    var loginedShow = RepoList();
    return appState.isLogined ? loginedShow : notLogindShow;
  }
}

class HomeDraw extends StatelessWidget {
  const HomeDraw({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSettingPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ThemeSettingPage()),
              );
            },
          ),
          Visibility(
            visible: appState.isLogined,
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirm to logout'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        appState.setToken(null);
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Setting"),
      ),
      body: const Column(
        children: [
          Text("English"),
          Text("简体中文"),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("token setting")),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final tokenController = TextEditingController();

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your github token';
            }
            return null;
          },
          decoration:
              const InputDecoration(labelText: "Enter your github token"),
          autofocus: true,
          controller: tokenController,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                var tokenIsValid = await isValid(tokenController.text);
                if (context.mounted && tokenIsValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login success")));
                  Navigator.pop(context);
                }
                if (context.mounted && !tokenIsValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid token!")));
                }
                if (tokenIsValid) {
                  appState.setToken(tokenController.text);
                }
              }
            },
            child: const Text("Submit"),
          ),
        )
      ]),
    );
  }
}

Future<bool> isValid(String token) async {
  var headers = {
    "Authorization": "Bearer $token",
    "X-GitHub-Api-Version": "2022-11-28",
  };
  final response = await http
      .head(Uri.parse("https://api.github.com/user/repos"), headers: headers);
  return response.statusCode == 200;
}

final colors = [
  Colors.amber,
  Colors.green,
  Colors.grey,
  Colors.blue,
  Colors.orange
];

class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Theme Setting")),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            for (Color color in colors)
              Column(
                children: [
                  ThemeSettingItem(color: color),
                  const SizedBox(height: 5)
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ThemeSettingItem extends StatelessWidget {
  const ThemeSettingItem({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return GestureDetector(
      child: Container(
        color: color,
        height: 40,
      ),
      onTap: () {
        appState.setThemeColor(color);
      },
    );
  }
}
