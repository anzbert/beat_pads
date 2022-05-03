import 'package:flutter/material.dart';
import 'dart:math';

import 'package:beat_pads/services/_services.dart';

class Settings extends ChangeNotifier {
  Settings(this.prefs);
  Prefs prefs;

  resetAll() async {
    await prefs.resetStoredValues();
    prefs = await Prefs.initAsync();
    notifyListeners();
  }

  // MPE settings (testing)
  double maxMPEControlDrawRadius =
      110; // TODO : fixed/ changable or screen dependant?
  double moveThreshhold = 0.1;
  final int memberChannels = 8; // temp fixed
  bool upperZone = false; // temp fixed

  // ROUND ROBBIN METHOD
  int _channelCounter = -1;
  int get memberChan {
    if (playMode != PlayMode.mpe) return channel;
    int upperLimit = upperZone ? 14 : memberChannels;
    int lowerLimit = upperZone ? 15 - memberChannels : 1;

    _channelCounter = _channelCounter == -1 ? lowerLimit : _channelCounter;

    _channelCounter++;

    if (_channelCounter > upperLimit || _channelCounter < lowerLimit) {
      _channelCounter = lowerLimit;
    }

    return _channelCounter;
  }

// channel (master channel):
  int get channel {
    if (playMode == PlayMode.mpe) {
      return upperZone ? 15 : 0;
    }
    return prefs.settings.channel.value;
  }

  set channel(int newChannel) {
    if (newChannel < 0 || newChannel > 15) return;
    if (playMode == PlayMode.mpe) {
      if (newChannel != 0 || newChannel != 15) return;
    }

    prefs.settings.channel.value = newChannel;
    prefs.settings.channel.save();
    notifyListeners();
  }

  // layout:
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

  // lock screen button:
  bool get lockScreenButton => prefs.settings.lockScreenButton.value;

  set lockScreenButton(bool newValue) {
    prefs.settings.lockScreenButton.value = newValue;
    prefs.settings.lockScreenButton.save();
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
