import 'package:beat_pads/components/drop_down_interval.dart';
import 'package:beat_pads/services/midi_utils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Settings extends ChangeNotifier {
  // basenote:
  int _baseNote = 36;

  set baseNote(int note) {
    if (note < 0 || note > 127) return;
    _baseNote = note;
    notifyListeners();
  }

  int get baseNote => _baseNote;
  resetBaseNote() => baseNote = 36;

  // pad dimensions
  final List<int> _padDimensions = [4, 4]; // [ W, H ]
  int get width => _padDimensions[0];
  int get height => _padDimensions[1];
  // int get totalNumPads => _padDimensions[0] * _padDimensions[1];

  set padDimensions(List<int> newDims) {
    if (newDims.length != 2) return;
    if (baseNote + newDims[0] * newDims[1] > 127) {
      int maxValue = 128 - newDims[0] * newDims[1];
      baseNote = maxValue;
    }
    _padDimensions[0] = newDims[0];
    _padDimensions[1] = newDims[1];
    notifyListeners();
  }

  set width(int newValue) => padDimensions = [newValue, height];
  set height(int newValue) => padDimensions = [width, newValue];

// scale:
  String _scale = midiScales.keys.toList()[0];
  String get scale => _scale;

  set scale(String newValue) {
    String validatedScale = newValue;
    if (!midiScales.containsKey(newValue)) {
      validatedScale = midiScales.keys.toList()[0]; // set to default
    }
    _scale = validatedScale;
    notifyListeners();
  }

// row interval:
  RowInterval _rowInterval = RowInterval.majorThird; // semitones
  RowInterval get rowInterval => _rowInterval;

  set rowInterval(RowInterval newValue) {
    _rowInterval = newValue;
    notifyListeners();
  }

// TODO: "only-scale-notes mode" works only when interval is continuous

// only scale notes:
  bool _onlyScaleNotes = false;
  bool get onlyScaleNotes => _onlyScaleNotes;

  set onlyScaleNotes(bool newValue) {
    _onlyScaleNotes = newValue;
    notifyListeners();
  }

// pitchbend:
  bool _pitchBend = false;
  bool get pitchBend => _pitchBend;

  set pitchBend(bool newValue) {
    _pitchBend = newValue;
    notifyListeners();
  }

// lock screen button:
  bool _lockScreenButton = false;
  bool get lockScreenButton => _lockScreenButton;

  set lockScreenButton(bool newValue) {
    _lockScreenButton = newValue;
    notifyListeners();
  }

// velocity:
  bool randomVelocity = false;
  final _random = Random();

  set randomizeVelocity(bool setTo) {
    randomVelocity = setTo;
    notifyListeners();
  }

  int _velocity = 110;

  int _velocityMin = 110;
  int _velocityMax = 120;
  int get velocityMin => _velocityMin;
  int get velocityMax => _velocityMax;

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

  resetVelocity() {
    if (!randomVelocity) {
      _velocity = 110;
    } else {
      _velocityMax = 120;
      _velocityMin = 110;
    }
    notifyListeners();
  }

// notenames:
  bool _showNoteNames = false;
  bool get showNoteNames => _showNoteNames;

  set showNoteNames(bool setting) {
    _showNoteNames = setting;
    notifyListeners();
  }
}
