import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiReceiver extends ChangeNotifier {
  StreamSubscription<MidiPacket>? _rxSubscription;

  final MidiCommand _midiCommand = MidiCommand();

  final rxNotes = List.filled(128, 0);

  int _channel = 0;
  set channel(int channel) {
    if (channel < 0 || channel > 15) return;
    _channel = channel;
    notifyListeners();
  }

  int get channel => _channel;
  resetChannel() => channel = 0;

  MidiReceiver() {
    _rxSubscription = _midiCommand.onMidiDataReceived?.listen((packet) {
      int header = packet.data[0];

      // print(
      //     "${packet.data} @ ${packet.timestamp} from ${packet.device.name} / ID:${packet.device.id}");

      // If the message is NOT a command (0xFn), and NOT using the correct channel -> return:
      if (header & 0xF0 != 0xF0 && header & 0x0F != _channel) return;

      MidiMessageType type = getMidiMessageType(header);

      if (type == MidiMessageType.noteOn || type == MidiMessageType.noteOff) {
        // receiver only handling noteON(9) and noteOFF(8) at the moment:
        int note = packet.data[1];
        int velocity = packet.data[2];

        switch (type) {
          case MidiMessageType.noteOn:
            rxNotes[note] = velocity;
            notifyListeners();
            break;
          case MidiMessageType.noteOff:
            rxNotes[note] = 0;
            notifyListeners();
            break;
          default:
            return;
        }
      }
    });
  }

  @override
  void dispose() {
    _rxSubscription?.cancel();
    super.dispose();
  }
}

// UTILITY FUNCTIONS (not all of them in use):

int lengthOfMessageType(int type) {
  // sysex not included, as it is of variable length
  List<int> commands1Bytes = [0xF6, 0xF8, 0xFA, 0xFB, 0xFC, 0xFF, 0xFE];
  List<int> commands2Bytes = [0xF1, 0xF3];
  List<int> commands3Bytes = [0xF2];
  if (commands1Bytes.contains(type)) return 1;
  if (commands2Bytes.contains(type)) return 2;
  if (commands3Bytes.contains(type)) return 3;

  int midiType = type & 0xF0;
  List<int> midi2Bytes = [0xC0, 0xD0];
  List<int> midi3Bytes = [0x80, 0x90, 0xA0, 0xB0, 0xE0];
  if (midi2Bytes.contains(midiType)) return 2;
  if (midi3Bytes.contains(midiType)) return 3;

  return 0;
}

enum MidiMessageType {
  unknown,

  noteOn,
  noteOff,
  aftertouch,
  cc,
  programChange,
  polyphonicAftertouch,
  pitchBend,
  sysExStart,
  midiTimeCode,
  positionPointer,
  songSelect,
  tuneRequest,
  sysExEnd,
  timingClock,
  start,
  cont,
  stop,
  activeSensing,
  systemReset
}

MidiMessageType getMidiMessageType(int type) {
  if (type == 0xF0) return MidiMessageType.sysExStart;
  if (type == 0xF1) return MidiMessageType.midiTimeCode;
  if (type == 0xF2) return MidiMessageType.positionPointer;
  if (type == 0xF3) return MidiMessageType.songSelect;

  if (type == 0xF6) return MidiMessageType.tuneRequest;
  if (type == 0xF7) return MidiMessageType.sysExEnd;
  if (type == 0xF8) return MidiMessageType.timingClock;

  if (type == 0xFA) return MidiMessageType.start;
  if (type == 0xFB) return MidiMessageType.cont;
  if (type == 0xFC) return MidiMessageType.stop;

  if (type == 0xFE) return MidiMessageType.activeSensing;
  if (type == 0xFF) return MidiMessageType.systemReset;

  int midiType = type & 0xF0;
  if (midiType == 0xA0) return MidiMessageType.polyphonicAftertouch;
  if (midiType == 0xB0) return MidiMessageType.cc;
  if (midiType == 0xC0) return MidiMessageType.programChange;
  if (midiType == 0xD0) return MidiMessageType.aftertouch;
  if (midiType == 0xE0) return MidiMessageType.pitchBend;

  if (midiType == 0x80) return MidiMessageType.noteOff;
  if (midiType == 0x90) return MidiMessageType.noteOn;

  return MidiMessageType.unknown;
}
