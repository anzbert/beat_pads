import 'package:flutter/material.dart';
import 'dart:math';

import 'package:beat_pads/services/_services.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class Settings extends ChangeNotifier {
  Settings(this.prefs);
  Prefs prefs;

  resetAll() async {
    await prefs.resetStoredValues();
    prefs = await Prefs.initAsync();
    notifyListeners();
  }

  List<MidiDevice> _connectedDevices = [];
  List<MidiDevice> get connectedDevices => _connectedDevices;
  set connectedDevices(List<MidiDevice> newVal) {
    _connectedDevices = newVal;
    notifyListeners();
  }

  // colored Intervals:
  bool get coloredIntervals => prefs.settings.coloredIntervals.value;

  set coloredIntervals(bool newValue) {
    prefs.settings.coloredIntervals.value = newValue;
    prefs.settings.coloredIntervals.save();
    notifyListeners();
  }

  // # for dropdown menu:
  MPEmods get mpe2DX => prefs.settings.mpe2DX.value;
  set mpe2DX(MPEmods newVal) {
    prefs.settings.mpe2DX.value = newVal;
    prefs.settings.mpe2DX.save();
    notifyListeners();
  }

  MPEmods get mpe2DY => prefs.settings.mpe2DY.value;
  set mpe2DY(MPEmods newVal) {
    prefs.settings.mpe2DY.value = newVal;
    prefs.settings.mpe2DY.save();
    notifyListeners();
  }

  MPEmods get mpe1DRadius => prefs.settings.mpe1DRadius.value;
  set mpe1DRadius(MPEmods newVal) {
    prefs.settings.mpe1DRadius.value = newVal;
    prefs.settings.mpe1DRadius.save();
    notifyListeners();
  }
  // # end of dropdown menus

  int get mpePitchbendRange => prefs.settings.mpePitchBendRange.value;
  set mpePitchbendRange(int newVal) {
    if (newVal > 48 || newVal < 0) return;
    prefs.settings.mpePitchBendRange.value = newVal;
    prefs.settings.mpePitchBendRange.save();
    notifyListeners();
  }

  void resetMPEPitchbendRange() =>
      mpePitchbendRange = LoadSettings.defaults().mpePitchBendRange.value;

  double get modulationRadius => prefs.settings.modulationRadius.value / 100;
  set modulationRadius(double newVal) {
    prefs.settings.modulationRadius.value = (newVal.clamp(0, 1) * 100).toInt();
    prefs.settings.modulationRadius.save();
    notifyListeners();
  }

  void resetModulationRadius() =>
      modulationRadius = LoadSettings.defaults().modulationRadius.value / 100;

  double get modulationDeadZone =>
      prefs.settings.modulationDeadZone.value / 100;
  set modulationDeadZone(double newVal) {
    prefs.settings.modulationDeadZone.value =
        (newVal.clamp(0, 1) * 100).toInt();
    prefs.settings.modulationDeadZone.save();
    notifyListeners();
  }

  void resetDeadZone() => modulationDeadZone =
      LoadSettings.defaults().modulationDeadZone.value / 100;

  bool get modulation2D => prefs.settings.modulation2D.value;
  set modulation2D(bool newVal) {
    prefs.settings.modulation2D.value = newVal;
    prefs.settings.modulation2D.save();
    notifyListeners();
  }

  int get mpeMemberChannels => prefs.settings.mpeMemberChannels.value;
  set mpeMemberChannels(int newVal) {
    prefs.settings.mpeMemberChannels.value = newVal.clamp(1, 15);
    prefs.settings.mpeMemberChannels.save();
    notifyListeners();
  }

  void resetMpeMemberChannels() =>
      mpeMemberChannels = LoadSettings.defaults().mpeMemberChannels.value;

  // CHANNEL (= Master Channel):
  int get channel {
    if (playMode == PlayMode.mpe) {
      return prefs.settings.channel.value > 7 ? 15 : 0;
    }
    return prefs.settings.channel.value;
  }

  set channel(int newChannel) {
    if (newChannel < 0 || newChannel > 15) return;

    if (playMode == PlayMode.mpe) {
      if (newChannel < 8) prefs.settings.channel.value = 0;
      if (newChannel > 7) prefs.settings.channel.value = 15;
    } else {
      prefs.settings.channel.value = newChannel;
    }
    prefs.settings.channel.save();
    notifyListeners();
  }

  void resetChannel() => channel = LoadSettings.defaults().channel.value;

  bool get upperZone => prefs.settings.channel.value > 7 ? true : false;
  set upperZone(bool newZone) => channel = newZone ? 15 : 0;

  // LAYOUT:
  Layout get layout => prefs.settings.layout.value;

  set layout(Layout newLayout) {
    if (newLayout.props.resizable == false) {
      prefs.settings.rootNote.value = 0;
      prefs.settings.rootNote.save();
      prefs.settings.scaleString.value =
          LoadSettings.defaults().scaleString.value;
      prefs.settings.scaleString.save();
    }

    if (prefs.settings.width.value != newLayout.props.defaultDimensions.x) {
      prefs.settings.width.value = newLayout.props.defaultDimensions.x;
      prefs.settings.width.save();
    }
    if (prefs.settings.height.value != newLayout.props.defaultDimensions.y) {
      prefs.settings.height.value = newLayout.props.defaultDimensions.y;
      prefs.settings.height.save();
    }

    prefs.settings.layout.value = newLayout;
    prefs.settings.layout.save();

    notifyListeners();
  }

  // play mode
  PlayMode get playMode => prefs.settings.playMode.value;

  set playMode(PlayMode newValue) {
    prefs.settings.playMode.value = newValue;
    prefs.settings.playMode.save();
    notifyListeners();
  }

  // pad grid:
  List<List<int>> get rows {
    return prefs.settings.layout.value.getGrid(this).rows;
  }

  List<int> get grid {
    return prefs.settings.layout.value.getGrid(this).list;
  }

  // root note:
  set rootNote(int note) {
    if (note < 0 || note > 11) return;
    prefs.settings.rootNote.value = note;
    prefs.settings.rootNote.save();
    prefs.settings.base.value = note;
    prefs.settings.base.save();
    notifyListeners();
  }

  int get rootNote => prefs.settings.rootNote.value;
  resetRootNote() => rootNote = LoadSettings.defaults().rootNote.value;

  // base note:
  int get base => prefs.settings.base.value;

  set base(int note) {
    if (note < 0 || note > 11) return;
    prefs.settings.base.value = note;
    prefs.settings.base.save();
    notifyListeners();
  }

  int get baseOctave => prefs.settings.baseOctave.value;

  set baseOctave(int octave) {
    if (octave < -2 || octave > 7) return;
    prefs.settings.baseOctave.value = octave;
    prefs.settings.baseOctave.save();
    notifyListeners();
  }

  resetBaseOctave() => baseOctave = LoadSettings.defaults().baseOctave.value;

  int get baseNote =>
      (prefs.settings.baseOctave.value + 2) * 12 + prefs.settings.base.value;
  set baseNote(int note) {
    prefs.settings.base.value = note % 12;
    prefs.settings.baseOctave.value = (note ~/ 12) - 2;
    prefs.settings.base.save();
    prefs.settings.baseOctave.save();
    notifyListeners();
  }

  // pad dimensions
  int get width => prefs.settings.width.value;
  int get height => prefs.settings.height.value;

  set width(int newValue) {
    prefs.settings.width.value = newValue;
    prefs.settings.width.save();
    notifyListeners();
  }

  set height(int newValue) {
    prefs.settings.height.value = newValue;
    prefs.settings.height.save();
    notifyListeners();
  }

  // scale:
  String get scaleString => prefs.settings.scaleString.value;
  List<int> get scaleList => midiScales[prefs.settings.scaleString.value]!;

  set scaleString(String newValue) {
    prefs.settings.scaleString.value = newValue;
    prefs.settings.scaleString.save();
    notifyListeners();
  }

  // octave buttons:
  bool get octaveButtons => prefs.settings.octaveButtons.value;

  set octaveButtons(bool newValue) {
    prefs.settings.octaveButtons.value = newValue;
    prefs.settings.octaveButtons.save();
    notifyListeners();
  }

  // sustain button:
  bool get sustainButton => prefs.settings.sustainButton.value;

  set sustainButton(bool newValue) {
    prefs.settings.sustainButton.value = newValue;
    prefs.settings.sustainButton.save();
    notifyListeners();
  }

  // velocity:
  bool get randomVelocity => prefs.settings.randomVelocity.value;
  set randomizeVelocity(bool newValue) {
    prefs.settings.randomVelocity.value = newValue;
    prefs.settings.randomVelocity.save();
    notifyListeners();
  }

  int get velocityMin => prefs.settings.velocityMin.value;
  int get velocityMax => prefs.settings.velocityMax.value;

  final _random = Random();
  int get velocity {
    if (!randomVelocity) return prefs.settings.velocity.value;
    int randVelocity = _random.nextInt(prefs.settings.velocityMax.value -
            prefs.settings.velocityMin.value) +
        prefs.settings.velocityMin.value;
    return randVelocity > 127 ? 127 : randVelocity;
  }

  set velocityMin(int min) {
    if (min < 0 || min > prefs.settings.velocityMax.value) return;
    prefs.settings.velocityMin.value = min;
    prefs.settings.velocityMin.save();
    notifyListeners();
  }

  set velocityMax(int max) {
    if (max < prefs.settings.velocityMin.value || max > 127) return;
    prefs.settings.velocityMax.value = max;
    prefs.settings.velocityMax.save();
    notifyListeners();
  }

  set velocity(int vel) {
    if (vel < 0 || vel > 127) return;
    prefs.settings.velocity.value = vel;
    prefs.settings.velocity.save();
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
  bool get showNoteNames => prefs.settings.showNoteNames.value;

  set showNoteNames(bool newValue) {
    prefs.settings.showNoteNames.value = newValue;
    prefs.settings.showNoteNames.save();
    notifyListeners();
  }

  // send CC:
  bool get sendCC => prefs.settings.sendCC.value;

  set sendCC(bool newValue) {
    prefs.settings.sendCC.value = newValue;
    prefs.settings.sendCC.save();
    notifyListeners();
  }

  // sustain:
  int get sustainTimeStep => prefs.settings.sustainTimeStep.value;

  set sustainTimeStep(int timeInMs) {
    prefs.settings.sustainTimeStep.value = timeInMs;
    prefs.settings.sustainTimeStep.save();
    notifyListeners();
  }

  int get sustainTimeUsable => (100 * sustainTimeStep).toInt();

  resetSustainTimeStep() =>
      sustainTimeStep = LoadSettings.defaults().sustainTimeStep.value;

// pitchbend:
  bool get pitchBend => prefs.settings.pitchBend.value;

  set pitchBend(bool newValue) {
    prefs.settings.pitchBend.value = newValue;
    prefs.settings.pitchBend.save();

    if (!newValue) {
      prefs.settings.pitchBendEase.value =
          LoadSettings.defaults().pitchBendEase.value;
      prefs.settings.pitchBendEase.save();
    }

    notifyListeners();
  }

// pitchBendEase
  int get pitchBendEase => prefs.settings.pitchBendEase.value;

  set pitchBendEase(int timeInMs) {
    prefs.settings.pitchBendEase.value = timeInMs;
    prefs.settings.pitchBendEase.save();
    notifyListeners();
  }

  int get pitchBendEaseCalculated => (100 * pitchBendEase).toInt();

  resetPitchBendEase() =>
      pitchBendEase = LoadSettings.defaults().pitchBendEase.value;

// modWheel
  bool get modWheel => prefs.settings.modWheel.value;

  set modWheel(bool newValue) {
    prefs.settings.modWheel.value = newValue;
    prefs.settings.modWheel.save();
    notifyListeners();
  }
}
