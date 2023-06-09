import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Github Client App'),
      ),
      drawer: Drawer(
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
                    builder: (context) => const LanguagePage(),
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
                  MaterialPageRoute(builder: (context) => const ThemeSetting()),
                );
              },
            ),
            ListTile(
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
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: const Text("login"),
        ),
      ),
    );
  }
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

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

  @override
  Widget build(BuildContext context) {
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Processing data...")));
              }
            },
            child: const Text("Submit"),
          ),
        )
      ]),
    );
  }
}

class AppState extends ChangeNotifier {
  String? token;
  Color themeColor = Colors.deepPurple;

  bool get isLogined => token == null;
  void setToken(String token) {
    this.token = token;
    notifyListeners();
  }

  void setThemeColor(Color themeColor) {
    this.themeColor = themeColor;
    notifyListeners();
  }
}

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Theme Setting")),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.deepPurpleAccent,
                height: 40,
              ),
              onTap: () {
                appState.setThemeColor(Colors.deepPurpleAccent);
              },
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              child: Container(
                color: Colors.deepOrangeAccent,
                height: 40,
              ),
              onTap: () {
                appState.setThemeColor(Colors.deepOrangeAccent);
              },
            ),
          ],
        ),
      ),
    );
  }
}
