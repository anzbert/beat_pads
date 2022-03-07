import 'package:flutter/material.dart';
import 'dart:math';

class Settings extends ChangeNotifier {
// velocity:
  final _random = Random();

  bool randomVelocity = false;
  randomizeVelocity(bool setTo) {
    randomVelocity = setTo;
    notifyListeners();
  }

  int _velocityMin = 100;
  int _velocityMax = 127;
  int _velocity = 100;

  int get velocity {
    if (!randomVelocity) return _velocity;

    int randVelocity =
        _random.nextInt(_velocityMax - _velocityMin) + _velocityMin;
    return randVelocity > 127 ? 127 : randVelocity;
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

  set velocity(int vel) {
    if (vel < 0 || vel > 127) return;
    _velocity = vel;
    notifyListeners();
  }

  int get velocityMin {
    return _velocityMin;
  }

  int get velocityMax {
    return _velocityMax;
  }

  resetVelocity() {
    if (!randomVelocity) {
      _velocity = 100;
    } else {
      _velocityMax = 127;
      _velocityMin = 100;
    }
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
