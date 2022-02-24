import 'package:flutter/material.dart';
import 'dart:math';

class Settings extends ChangeNotifier {
// channel:
  int _channel = 1;

  set channel(int chan) {
    if (chan < 0 || chan > 15) return;
    _channel = chan;
    notifyListeners();
  }

  int get channel {
    return _channel;
  }

// velocity:
  final _random = Random();
  int _velocityMin = 127;
  int _velocityMax = 127;

  int get velocity {
    if (_velocityMin == _velocityMax) return _velocityMin;

    int randomVelocity =
        _random.nextInt(_velocityMax - _velocityMin) + _velocityMin;
    return randomVelocity > 127 ? 127 : randomVelocity;
  }

  set velocityMin(int min) {
    if (min < 0 || min > _velocityMax) return;
    _velocityMin = min;
    notifyListeners();
  }

  set velocityMax(int max) {
    if (max < _velocityMin || max > 127) return;
    _velocityMax = max;
    notifyListeners();
  }

  int get velocityMin {
    return _velocityMin;
  }

  int get velocityMax {
    return _velocityMax;
  }

  resetVelocity() {
    _velocityMax = 127;
    _velocityMin = 127;
    notifyListeners();
  }

// default:
  resetAll() {
    _channel = 1;
    _baseNote = 36;
    noteNames = false;
    _velocityMax = 127;
    _velocityMin = 127;
    notifyListeners();
  }

// basenote:
  int _baseNote = 36;

  resetBaseNote() {
    _baseNote = 36;
    notifyListeners();
  }

  set baseNote(int note) {
    if (note < 0 || note > 127) return;
    _baseNote = note;
    notifyListeners();
  }

  int get baseNote {
    return _baseNote;
  }

// notenames:
  bool noteNames = false;

  void showNoteNames(bool setting) {
    noteNames = setting;
    notifyListeners();
  }
}
