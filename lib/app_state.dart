import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String? token;
  Color themeColor = Colors.deepPurple;

  bool get isLogined => token != null;
  void setToken(String? token) {
    this.token = token;
    notifyListeners();
  }

  void setThemeColor(Color themeColor) {
    this.themeColor = themeColor;
    notifyListeners();
  }
}
