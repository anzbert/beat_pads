import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  int _base = 36;

  bool noteNames = false;

  resetAll() {
    _base = 36;
    noteNames = false;
    notifyListeners();
  }

  resetBaseNote() {
    _base = 36;
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
