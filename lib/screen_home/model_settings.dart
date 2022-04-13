import 'package:flutter/material.dart';
import 'dart:math';

import 'package:beat_pads/services/_services.dart';

class Settings extends ChangeNotifier {
  Settings(this.prefs)
      : _layout = prefs.loadSettings.layout,
        _rootNote = prefs.loadSettings.rootNote,
        _baseOctave = prefs.loadSettings.baseOctave,
        _base = prefs.loadSettings.base,
        _velocity = prefs.loadSettings.velocity,
        _velocityMin = prefs.loadSettings.velocityMin,
        _velocityMax = prefs.loadSettings.velocityMax,
        _sustainTimeStep = prefs.loadSettings.sustainTimeStep,
        _sendCC = prefs.loadSettings.sendCC,
        _showNoteNames = prefs.loadSettings.showNoteNames,
        _pitchBend = prefs.loadSettings.pitchBend,
        _octaveButtons = prefs.loadSettings.octaveButtons,
        _lockScreenButton = prefs.loadSettings.lockScreenButton,
        _randomVelocity = prefs.loadSettings.randomVelocity,
        _scale = prefs.loadSettings.scale,
        _padDimensions = [
          prefs.loadSettings.width,
          prefs.loadSettings.height,
        ];

  Prefs prefs;

// TODO: check all reset and set functions!
// TODO: reset all / save all function

// layout:
  Layout _layout;
  Layout get layout => _layout;

  set layout(Layout newLayout) {
    if (newLayout.variable == false) {
      _padDimensions.setAll(0, [4, 4]);
      _showNoteNames = false;
      _scale = "chromatic";
    }

    _layout = newLayout;
    prefs.saveSetting("layout", newLayout.name);
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
  int _rootNote;

  set rootNote(int note) {
    if (note < 0 || note > 11) return;
    _rootNote = note;
    notifyListeners();
  }

  int get rootNote => _rootNote;
  resetRootNote() => rootNote = 0;

  // base note:
  int _base;
  int get base => _base;

  set base(int note) {
    if (note < 0 || note > 11) return;
    _base = note;
    notifyListeners();
  }

  int _baseOctave;
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
    _baseOctave = LoadSettings.defaults().baseOctave;
    prefs.saveSetting("baseOctave", _baseOctave);
    notifyListeners();
  }

  // pad dimensions
  final List<int> _padDimensions; // [ W, H ]

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
  String _scale;
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
  bool _pitchBend;
  bool get pitchBend => _pitchBend;

  set pitchBend(bool newValue) {
    _pitchBend = newValue;
    notifyListeners();
  }

// octave buttons:
  bool _octaveButtons;
  bool get octaveButtons => _octaveButtons;

  set octaveButtons(bool newValue) {
    _octaveButtons = newValue;
    notifyListeners();
  }

// lock screen button:
  bool _lockScreenButton;
  bool get lockScreenButton => _lockScreenButton;

  set lockScreenButton(bool newValue) {
    _lockScreenButton = newValue;
    notifyListeners();
  }

// velocity:
  bool _randomVelocity;
  int _velocity;
  int _velocityMin;
  int _velocityMax;

  bool get randomVelocity => _randomVelocity;
  set randomizeVelocity(bool setTo) {
    _randomVelocity = setTo;
    notifyListeners();
  }

  int get velocityMin => _velocityMin;
  int get velocityMax => _velocityMax;

  final _random = Random();
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
  bool _showNoteNames;
  bool get showNoteNames => _showNoteNames;

  set showNoteNames(bool setting) {
    _showNoteNames = setting;
    notifyListeners();
  }

  // send CC:
  bool _sendCC;
  bool get sendCC => _sendCC;

  set sendCC(bool setting) {
    _sendCC = setting;
    notifyListeners();
  }

  // sustain:
  int _sustainTimeStep = 2;
  int get minSustainTimeStep => _minSustainTimeStep;
  int get sustainTimeStep => _sustainTimeStep;

  set sustainTimeStep(int timeInMs) {
    _sustainTimeStep = timeInMs.clamp(0, 5000);
    notifyListeners();
  }

  final int _minSustainTimeStep = 2;
  int get sustainTimeExp {
    if (_sustainTimeStep <= _minSustainTimeStep) return 0;
    return pow(2, _sustainTimeStep).toInt();
  }

  resetSustainTimeStep() {
    _sustainTimeStep = _minSustainTimeStep;
    notifyListeners();
  }
}
