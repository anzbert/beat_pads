import 'package:flutter/material.dart';
import 'dart:math';

import 'package:beat_pads/services/_services.dart';

class Settings extends ChangeNotifier {
  Settings(this.prefs)
      : _layout = prefs.loadSettings.layout,
        _rootNote = prefs.loadSettings.rootNote,
        _channel = prefs.loadSettings.channel,
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
        _scaleString = prefs.loadSettings.scaleString,
        _width = prefs.loadSettings.width,
        _height = prefs.loadSettings.height;

  Prefs prefs;

  Setting<Layout> _layout;
  Setting<int> _rootNote;
  Setting<int> _height;
  Setting<int> _width;
  Setting<int> _base;
  Setting<int> _baseOctave;
  Setting<String> _scaleString;
  Setting<bool> _pitchBend;
  Setting<bool> _showNoteNames;
  Setting<int> _sustainTimeStep;
  Setting<bool> _sendCC;
  Setting<bool> _lockScreenButton;
  Setting<bool> _randomVelocity;
  Setting<bool> _octaveButtons;
  Setting<int> _velocity;
  Setting<int> _velocityMin;
  Setting<int> _velocityMax;
  Setting<int> _channel;

  resetAll() async {
    await prefs.resetStoredValues();
    prefs = await Prefs.initAsync();

    _layout = prefs.loadSettings.layout;
    _rootNote = prefs.loadSettings.rootNote;
    _baseOctave = prefs.loadSettings.baseOctave;
    _channel = prefs.loadSettings.channel;
    _base = prefs.loadSettings.base;
    _velocity = prefs.loadSettings.velocity;
    _velocityMin = prefs.loadSettings.velocityMin;
    _velocityMax = prefs.loadSettings.velocityMax;
    _sustainTimeStep = prefs.loadSettings.sustainTimeStep;
    _sendCC = prefs.loadSettings.sendCC;
    _showNoteNames = prefs.loadSettings.showNoteNames;
    _pitchBend = prefs.loadSettings.pitchBend;
    _octaveButtons = prefs.loadSettings.octaveButtons;
    _lockScreenButton = prefs.loadSettings.lockScreenButton;
    _randomVelocity = prefs.loadSettings.randomVelocity;
    _scaleString = prefs.loadSettings.scaleString;
    _width = prefs.loadSettings.width;
    _height = prefs.loadSettings.height;

    notifyListeners();
  }

  // layout:
  Layout get layout => _layout.value;

  set layout(Layout newLayout) {
    if (newLayout.props.resizable == false) {
      _rootNote.value = 0;
      _rootNote.save();
      _scaleString.value = LoadSettings.defaults().scaleString.value;
      _scaleString.save();
    }

    if (_width.value != newLayout.props.defaultDimensions.x) {
      _width.value = newLayout.props.defaultDimensions.x;
      _width.save();
    }
    if (_height.value != newLayout.props.defaultDimensions.y) {
      _height.value = newLayout.props.defaultDimensions.y;
      _height.save();
    }

    _layout.value = newLayout;
    _layout.save();

    notifyListeners();
  }

  // pads:
  List<List<int>> get rows {
    return _layout.value.getGrid(this).rows;
  }

  // root note:
  set rootNote(int note) {
    if (note < 0 || note > 11) return;
    _rootNote.value = note;
    _rootNote.save();
    _base.value = note; // TODO: is this always a good idea?
    _base.save();
    notifyListeners();
  }

  int get rootNote => _rootNote.value;
  resetRootNote() => rootNote = LoadSettings.defaults().rootNote.value;

  // base note:
  int get base => _base.value;

  set base(int note) {
    if (note < 0 || note > 11) return;
    _base.value = note;
    _base.save();
    notifyListeners();
  }

  int get baseOctave => _baseOctave.value;

  set baseOctave(int octave) {
    if (octave < -2 || octave > 7) return;
    _baseOctave.value = octave;
    _baseOctave.save();
    notifyListeners();
  }

  resetBaseOctave() => baseOctave = LoadSettings.defaults().baseOctave.value;

  int get baseNote => (_baseOctave.value + 2) * 12 + _base.value;
  set baseNote(int note) {
    _base.value = note % 12;
    _baseOctave.value = (note ~/ 12) - 2;
    _base.save();
    _baseOctave.save();
    notifyListeners();
  }

  // pad dimensions
  int get width => _width.value;
  int get height => _height.value;

  set width(int newValue) {
    _width.value = newValue;
    _width.save();
    notifyListeners();
  }

  set height(int newValue) {
    _height.value = newValue;
    _height.save();
    notifyListeners();
  }

  // scale:
  String get scaleString => _scaleString.value;
  List<int> get scaleList => midiScales[_scaleString.value]!;

  set scaleString(String newValue) {
    _scaleString.value = newValue;
    _scaleString.save();
    notifyListeners();
  }

  // pitchbend:
  bool get pitchBend => _pitchBend.value;

  set pitchBend(bool newValue) {
    _pitchBend.value = newValue;
    _pitchBend.save();
    notifyListeners();
  }

  // octave buttons:
  bool get octaveButtons => _octaveButtons.value;

  set octaveButtons(bool newValue) {
    _octaveButtons.value = newValue;
    _octaveButtons.save();
    notifyListeners();
  }

  // lock screen button:
  bool get lockScreenButton => _lockScreenButton.value;

  set lockScreenButton(bool newValue) {
    _lockScreenButton.value = newValue;
    _lockScreenButton.save();
    notifyListeners();
  }

  // velocity:
  bool get randomVelocity => _randomVelocity.value;
  set randomizeVelocity(bool newValue) {
    _randomVelocity.value = newValue;
    _randomVelocity.save();
    notifyListeners();
  }

  int get velocityMin => _velocityMin.value;
  int get velocityMax => _velocityMax.value;

  final _random = Random();
  int get velocity {
    if (!randomVelocity) return _velocity.value;
    int randVelocity =
        _random.nextInt(_velocityMax.value - _velocityMin.value) +
            _velocityMin.value;
    return randVelocity > 127 ? 127 : randVelocity;
  }

  set velocityMin(int min) {
    if (min < 0 || min > _velocityMax.value) return;
    _velocityMin.value = min;
    _velocityMin.save();
    notifyListeners();
  }

  set velocityMax(int max) {
    if (max < _velocityMin.value || max > 127) return;
    _velocityMax.value = max;
    _velocityMax.save();
    notifyListeners();
  }

  set velocity(int vel) {
    if (vel < 0 || vel > 127) return;
    _velocity.value = vel;
    _velocity.save();
    notifyListeners();
  }

  resetVelocity() {
    if (!randomVelocity) {
      velocity = LoadSettings.defaults().velocity.value;
    } else {
      velocityMax = LoadSettings.defaults().velocityMin.value;
      velocityMin = LoadSettings.defaults().velocityMax.value;
    }
  }

  // notenames:
  bool get showNoteNames => _showNoteNames.value;

  set showNoteNames(bool newValue) {
    _showNoteNames.value = newValue;
    _showNoteNames.save();
    notifyListeners();
  }

  // send CC:
  bool get sendCC => _sendCC.value;

  set sendCC(bool newValue) {
    _sendCC.value = newValue;
    _sendCC.save();
    notifyListeners();
  }

  // sustain:
  int get sustainTimeStep => _sustainTimeStep.value;

  set sustainTimeStep(int timeInMs) {
    _sustainTimeStep.value = timeInMs.clamp(0, 5000);
    _sustainTimeStep.save();
    notifyListeners();
  }

  int get minSustainTimeStep => 2;
  int get sustainTimeExp {
    if (_sustainTimeStep.value <= minSustainTimeStep) return 0;
    return pow(2, _sustainTimeStep.value).toInt();
  }

  resetSustainTimeStep() =>
      sustainTimeStep = LoadSettings.defaults().sustainTimeStep.value;

  // channel:
  int get channel => _channel.value;

  set channel(int newChannel) {
    if (newChannel < 0 || newChannel > 15) return;
    _channel.value = newChannel;
    _channel.save();
    notifyListeners();
  }

  resetChannel() => channel = LoadSettings.defaults().channel.value;
}
