import 'dart:async';

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

  // pads:
  List<List<int>> get rows {
    return prefs.settings.layout.value.getGrid(this).rows;
  }

  // root note:
  set rootNote(int note) {
    if (note < 0 || note > 11) return;
    prefs.settings.rootNote.value = note;
    prefs.settings.rootNote.save();
    prefs.settings.base.value = note; // TODO: is this always a good idea?
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

  // pitchbend:
  bool get pitchBend => prefs.settings.pitchBend.value;

  set pitchBend(bool newValue) {
    prefs.settings.pitchBend.value = newValue;
    prefs.settings.pitchBend.save();
    notifyListeners();
  }

  // octave buttons:
  bool get octaveButtons => prefs.settings.octaveButtons.value;

  set octaveButtons(bool newValue) {
    prefs.settings.octaveButtons.value = newValue;
    prefs.settings.octaveButtons.save();
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
    prefs.settings.sustainTimeStep.value = timeInMs.clamp(0, 5000);
    prefs.settings.sustainTimeStep.save();
    notifyListeners();
  }

  int get minSustainTimeStep => 2;
  int get sustainTimeExp {
    if (prefs.settings.sustainTimeStep.value <= minSustainTimeStep) return 0;
    return pow(2, prefs.settings.sustainTimeStep.value).toInt();
  }

  resetSustainTimeStep() =>
      sustainTimeStep = LoadSettings.defaults().sustainTimeStep.value;

  // channel:
  int get channel => prefs.settings.channel.value;

  set channel(int newChannel) {
    if (newChannel < 0 || newChannel > 15) return;
    prefs.settings.channel.value = newChannel;
    prefs.settings.channel.save();
    notifyListeners();
  }

  resetChannel() => channel = LoadSettings.defaults().channel.value;
}

// TODO move mide RX logic here somehow
class MidiRx {
  final List<int> rxNoteBuffer = List.filled(128, 0);

  rxNotesReset() {
    rxNoteBuffer.fillRange(0, 128, 0);
    // notifyListeners();
  }

  int channel = 0;

  StreamSubscription<MidiPacket>? _rxSubscription;
  final MidiCommand _midiCommand = MidiCommand();

// constructor:
  MidiData() {
    _rxSubscription = _midiCommand.onMidiDataReceived?.listen((packet) {
      int header = packet.data[0];

      // If the message is NOT a command (0xFn), and NOT using the correct channel -> return:
      if (header & 0xF0 != 0xF0 && header & 0x0F != channel) return;

      MidiMessageType type = MidiUtils.getMidiMessageType(header);

      if (type == MidiMessageType.noteOn || type == MidiMessageType.noteOff) {
        // Data only handling noteON(9) and noteOFF(8) at the moment:
        int note = packet.data[1];
        int velocity = packet.data[2];

        switch (type) {
          case MidiMessageType.noteOn:
            rxNoteBuffer[note] = velocity;
            // notifyListeners();
            break;
          case MidiMessageType.noteOff:
            rxNoteBuffer[note] = 0;
            // notifyListeners();
            break;
          default:
            return;
        }
      }
    });
  }
}
