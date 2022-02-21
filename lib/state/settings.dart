import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  bool noteNames = false;
  int _base = 36;

  reset() {
    _base = 36;
    noteNames = false;
    notifyListeners();
  }

  set baseNote(int value) {
    _base = value;
    notifyListeners();
  }

  int get baseNote {
    return _base;
  }

  void showNoteNames(bool setting) {
    noteNames = setting;
    notifyListeners();
  }
}
