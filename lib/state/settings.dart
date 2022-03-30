import 'package:beat_pads/services/pads_utils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:beat_pads/services/pads_layouts.dart';
import 'package:beat_pads/services/midi_utils.dart';

class Settings extends ChangeNotifier {
// layout:
  Layout _layout = Layout.continuous;
  Layout get layout => _layout;

  set layout(Layout newLayout) {
    if (newLayout.variable == false) {
      _padDimensions.setAll(0, [4, 4]);
      _showNoteNames = false;
      _scale = "chromatic";
    }

    _layout = newLayout;
    notifyListeners();
  }

// pads:
  List<List<int>> get rowsLists {
    return PadUtils.reversedRowLists(
      rootNote,
      baseNote,
      width,
      height,
      scaleList,
      layout,
    );
  }

  // lowest note:
  int _rootNote = 0;

  set rootNote(int note) {
    if (note < 0 || note > 11) return;
    _rootNote = note;
    notifyListeners();
  }

  int get rootNote => _rootNote;
  resetRootNote() => rootNote = 0;

  // base note:
  int _base = 0;
  int get base => _base;

  set base(int note) {
    if (note < 0 || note > 11) return;
    _base = note;
    notifyListeners();
  }

  int _baseOctave = 1;
  int get baseOctave => _baseOctave;

  set baseOctave(int octave) {
    if (octave < -2 || octave > 7) return;
    _baseOctave = octave;
    notifyListeners();
  }

  int get baseNote => (_baseOctave + 2) * 12 + _base;
  set baseNote(int note) {
    _base = note % 12;
    _baseOctave = (note ~/ 12) - 2;
    notifyListeners();
  }

  resetBaseOctave() {
    _baseOctave = 1;
    notifyListeners();
  }

  // pad dimensions
  final List<int> _padDimensions = [4, 4]; // [ W, H ]
  int get width => _padDimensions[0];
  int get height => _padDimensions[1];

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
  List<int> get scaleList => midiScales[_scale]!;

  set scale(String newValue) {
    String validatedScale = newValue;
    if (!midiScales.containsKey(newValue)) {
      validatedScale = midiScales.keys.toList()[0]; // set to default
    }
    _scale = validatedScale;

    notifyListeners();
  }

// pitchbend:
  bool _pitchBend = false;
  bool get pitchBend => _pitchBend;

  set pitchBend(bool newValue) {
    _pitchBend = newValue;
    notifyListeners();
  }

// octave buttons:
  bool _octaveButtons = false;
  bool get octaveButtons => _octaveButtons;

  set octaveButtons(bool newValue) {
    _octaveButtons = newValue;
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
  bool _showNoteNames = true;
  bool get showNoteNames => _showNoteNames;

  set showNoteNames(bool setting) {
    _showNoteNames = setting;
    notifyListeners();
  }

  // send CC:
  bool _sendCC = false;
  bool get sendCC => _sendCC;

  set sendCC(bool setting) {
    _sendCC = setting;
    notifyListeners();
  }

  // sustain:
  final int _minSustainTimeStep = 2;
  int get minSustainTimeStep => _minSustainTimeStep;

  int _sustainTimeStep = 2;
  int get sustainTimeStep => _sustainTimeStep;

  set sustainTimeStep(int timeInMs) {
    _sustainTimeStep = timeInMs.clamp(0, 5000);
    notifyListeners();
  }

  int get sustainTimeExp {
    if (_sustainTimeStep <= _minSustainTimeStep) return 0;
    return pow(2, _sustainTimeStep).toInt();
  }

  resetSustainTimeStep() {
    _sustainTimeStep = _minSustainTimeStep;
    notifyListeners();
  }
}
