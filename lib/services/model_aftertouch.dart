import 'package:flutter/material.dart';

class AftertouchModel extends ChangeNotifier {
  final Map<int, List<Offset>> _lineBuffer = {};

  get linesIterable {
    return _lineBuffer.values;
  }

  addLine(int key, List<Offset> line) {
    _lineBuffer[key] = line;
    notifyListeners();
  }

  updateEndPoint(int key, Offset endPoint) {
    if (_lineBuffer[key] != null) {
      _lineBuffer[key]![1] = endPoint;
    }
    notifyListeners();
  }

  removeLine(int key) {
    if (_lineBuffer[key] != null) {
      _lineBuffer.remove(key);
    }
    notifyListeners();
  }

  // TOUCH HANDLIMG
  push(PointerEvent touch, int note) {
    addLine(touch.pointer, [touch.position, touch.position]);
  }

  move(PointerEvent touch) {
    updateEndPoint(touch.pointer, touch.position);
  }

  lift(PointerEvent touch) {
    removeLine(touch.pointer);
  }
}
