import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  bool noteNames = false;

  void showNoteNames(bool setting) {
    noteNames = setting;
    notifyListeners();
  }
}
