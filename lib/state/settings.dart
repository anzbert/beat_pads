import 'package:flutter/material.dart';
import 'dart:math';

class Settings extends ChangeNotifier {
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

  // pad dimensions
  final List<int> _padDimensions = [4, 4]; // [ W, H ]

  set padDimensions(List<int> newDims) {
    if (newDims.length != 2) return;
    if (baseNote + newDims[0] * newDims[1] > 127) {
      int maxValue = 127 - newDims[0] * newDims[1];
      baseNote = maxValue;
    }
    _padDimensions[0] = newDims[0];
    _padDimensions[1] = newDims[1];
    notifyListeners();
  }

  List<int> get padDimensions {
    return _padDimensions;
  }

  int get width {
    return _padDimensions[0];
  }

  set width(int newValue) {
    padDimensions = [newValue, height];
  }

  int get height {
    return _padDimensions[1];
  }

  set height(int newValue) {
    padDimensions = [width, newValue];
  }

// scale:
  String _scale = 'chromatic';

  set scale(String newValue) {
    _scale = newValue;
    notifyListeners();
  }

  String get scale {
    return _scale;
  }

// pitchbend:
  bool _pitchBend = false;

  set pitchBend(bool newValue) {
    _pitchBend = newValue;
    notifyListeners();
  }

  bool get pitchBend {
    return _pitchBend;
  }

// lock screen button:
  bool _lockScreenButton = false;

  set lockScreenButton(bool newValue) {
    _lockScreenButton = newValue;
    notifyListeners();
  }

  bool get lockScreenButton {
    return _lockScreenButton;
  }

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

// notenames:
  bool noteNames = false;

  void showNoteNames(bool setting) {
    noteNames = setting;
    notifyListeners();
  }
}
