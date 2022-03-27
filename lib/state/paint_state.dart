import 'package:flutter/material.dart';

class PaintState extends ChangeNotifier {
  final Map<int, List<Offset>> _lines = {};

  get linesIterable {
    return _lines.values;
  }

  addLine(int key, List<Offset> line) {
    _lines[key] = line;
    notifyListeners();
  }

  removeLine(int key) {
    if (_lines[key] != null) {
      _lines.remove(key);
    }
    notifyListeners();
  }
}
