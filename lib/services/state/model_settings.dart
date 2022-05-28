import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/services/services.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class Settings extends ChangeNotifier {
  Prefs prefs;
  Settings(this.prefs);

  resetAll() async {
    await prefs.resetStoredValues();
    prefs = await Prefs.initAsync();
    notifyListeners();
  }

  // bool _virtualDevice = false;
  // bool get virtualDevice => _virtualDevice;
  // set virtualDevice(bool newValue) {
  //   _virtualDevice = newValue;
  //   notifyListeners();
  // }

  Menu _selectedMenu = Menu.layout;
  Menu get selectedMenu => _selectedMenu;
  set selectedMenu(Menu newMenu) {
    _selectedMenu = newMenu;
    notifyListeners();
  }

  List<MidiDevice> _connectedDevices = [];
  List<MidiDevice> get connectedDevices => _connectedDevices;
  set connectedDevices(List<MidiDevice> newVal) {
    _connectedDevices = newVal;
    notifyListeners();
  }

// notenames:
  PadLabels get padLabels => prefs.settings.padLabels.value;
  set padLabels(PadLabels newVal) {
    prefs.settings.padLabels.value = newVal;
    prefs.settings.padLabels.save();
    notifyListeners();
  }

  // colored Intervals:
  PadColors get padColors => prefs.settings.padColors.value;
  set padColors(PadColors newVal) {
    prefs.settings.padColors.value = newVal;
    prefs.settings.padColors.save();
    notifyListeners();
  }

  int get mpePitchbendRange => prefs.settings.mpePitchBendRange.value;
  set mpePitchbendRange(int newVal) {
    prefs.settings.mpePitchBendRange.value = newVal.clamp(0, 48);
    prefs.settings.mpePitchBendRange.save();
    notifyListeners();
  }

  void resetMPEPitchbendRange() =>
      mpePitchbendRange = LoadSettings.defaults().mpePitchBendRange.value;

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

  int get baseHue => prefs.settings.baseHue.value;
  set baseHue(int newVal) {
    prefs.settings.baseHue.value = newVal.clamp(0, 360);
    prefs.settings.baseHue.save();
    notifyListeners();
  }

  void resetBaseHue() => baseHue = LoadSettings.defaults().baseHue.value;

  double get modulationRadius => prefs.settings.modulationRadius.value / 100;
  double absoluteRadius(BuildContext context) =>
      MediaQuery.of(context).size.longestSide * modulationRadius;
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
    if (playMode == PlayMode.mpe) {
      if (newChannel < 8) prefs.settings.channel.value = 0;
      if (newChannel > 7) prefs.settings.channel.value = 15;
    } else {
      prefs.settings.channel.value = newChannel.clamp(0, 15);
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
      prefs.settings.rootNote.value = 0; // C
      prefs.settings.rootNote.save();
      prefs.settings.scaleString.value =
          LoadSettings.defaults().scaleString.value; // chromatic
      prefs.settings.scaleString.save();
    }

    if (newLayout.props.defaultDimensions?.x != null) {
      prefs.settings.width.value = newLayout.props.defaultDimensions!.x;
      prefs.settings.width.save();
    }
    if (newLayout.props.defaultDimensions?.y != null) {
      prefs.settings.height.value = newLayout.props.defaultDimensions!.y;
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
    prefs.settings.rootNote.value = note.clamp(0, 11);
    prefs.settings.rootNote.save();
    prefs.settings.base.value = note.clamp(0, 11);
    prefs.settings.base.save();
    notifyListeners();
  }

  int get rootNote => prefs.settings.rootNote.value;
  resetRootNote() => rootNote = LoadSettings.defaults().rootNote.value;

  // base note:
  int get base => prefs.settings.base.value;

  set base(int note) {
    prefs.settings.base.value = note.clamp(0, 11);
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
  int get width => prefs.settings.width.value.clamp(3, 16);
  int get height => prefs.settings.height.value.clamp(3, 16);

  set width(int newValue) {
    if (newValue < 3 || newValue > 16) return;
    prefs.settings.width.value = newValue;
    prefs.settings.width.save();
    notifyListeners();
  }

  set height(int newValue) {
    if (newValue < 3 || newValue > 16) return;
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

  // unlink sustain times button:
  bool get unlinkSustainTimes => prefs.settings.unlinkSustainTimes.value;
  set unlinkSustainTimes(bool newValue) {
    prefs.settings.unlinkSustainTimes.value = newValue;
    prefs.settings.unlinkSustainTimes.save();
    notifyListeners();
  }

  // RANDOM VELOCITY:
  bool get randomVelocity => prefs.settings.randomVelocity.value;
  set randomizeVelocity(bool newValue) {
    prefs.settings.randomVelocity.value = newValue;
    prefs.settings.randomVelocity.save();
    notifyListeners();
  }

  int get velocityMin => prefs.settings.velocityMin.value;
  int get velocityMax => prefs.settings.velocityMax.value;
  int get velocityRange => velocityMax - velocityMin;
  double get velocityCenter => (velocityMax + velocityMin) / 2;

  set velocityMin(int min) {
    prefs.settings.velocityMin.value = min;
    prefs.settings.velocityMin.save();
    notifyListeners();
  }

  set velocityMax(int max) {
    prefs.settings.velocityMax.value = max;
    prefs.settings.velocityMax.save();
    notifyListeners();
  }

  setVelocity(int vel, {bool save = true}) {
    prefs.settings.velocity.value = vel.clamp(10, 127);
    if (save) prefs.settings.velocity.save();
    notifyListeners();
  }

  int get velocity => prefs.settings.velocity.value;

  resetVelocity() {
    if (!randomVelocity) {
      setVelocity(LoadSettings.defaults().velocity.value);
    } else {
      velocityMax = LoadSettings.defaults().velocityMax.value;
      velocityMin = LoadSettings.defaults().velocityMin.value;
    }
  }

  // send CC:
  bool get sendCC => prefs.settings.sendCC.value;

  set sendCC(bool newValue) {
    prefs.settings.sendCC.value = newValue;
    prefs.settings.sendCC.save();
    notifyListeners();
  }

  // velocity slider:
  bool get velocitySlider => prefs.settings.velocitySlider.value;

  set velocitySlider(bool newValue) {
    prefs.settings.velocitySlider.value = newValue;
    prefs.settings.velocitySlider.save();
    notifyListeners();
  }

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

// modWheel
  bool get modWheel => prefs.settings.modWheel.value;

  set modWheel(bool newValue) {
    prefs.settings.modWheel.value = newValue;
    prefs.settings.modWheel.save();
    notifyListeners();
  }

// pitchBendEase
  int get pitchBendEase => prefs.settings.pitchBendEase.value
      .clamp(0, Timing.timingSteps.length - 1);

  set pitchBendEase(int newValue) {
    prefs.settings.pitchBendEase.value =
        newValue.clamp(0, Timing.timingSteps.length - 1);
    prefs.settings.pitchBendEase.save();
    notifyListeners();
  }

  int get pitchBendEaseUsable =>
      Timing.timingSteps[pitchBendEase.clamp(0, Timing.timingSteps.length - 1)];

  resetPitchBendEase() =>
      pitchBendEase = LoadSettings.defaults().pitchBendEase.value;

// note sustain:
  int get noteSustainTimeStep => prefs.settings.noteSustainTimeStep.value
      .clamp(0, Timing.timingSteps.length ~/ 1.5);

  set noteSustainTimeStep(int newValue) {
    prefs.settings.noteSustainTimeStep.value =
        newValue.clamp(0, Timing.timingSteps.length ~/ 1.5);

    prefs.settings.noteSustainTimeStep.save();
    notifyListeners();
  }

  int get noteSustainTimeUsable => Timing.timingSteps[
      noteSustainTimeStep.clamp(0, Timing.timingSteps.length ~/ 1.5)];

  resetNoteSustainTimeStep() =>
      noteSustainTimeStep = LoadSettings.defaults().noteSustainTimeStep.value;

// modulation sustain:
  int get modSustainTimeStep => prefs.settings.modSustainTimeStep.value
      .clamp(0, Timing.timingSteps.length ~/ 1.5);

  set modSustainTimeStep(int newValue) {
    prefs.settings.modSustainTimeStep.value =
        newValue.clamp(0, Timing.timingSteps.length ~/ 1.5);

    prefs.settings.modSustainTimeStep.save();
    notifyListeners();
  }

  int get modSustainTimeUsable => Timing.timingSteps[
      modSustainTimeStep.clamp(0, Timing.timingSteps.length ~/ 1.5)];

  resetModSustainTimeStep() =>
      modSustainTimeStep = LoadSettings.defaults().modSustainTimeStep.value;
}
