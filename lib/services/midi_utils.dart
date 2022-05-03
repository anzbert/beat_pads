import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

import './midi_const.dart';

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

abstract class MidiUtils {
  /// Kill all notes on a channel
  static void sendKillAllMessage(int channel) {
    CCMessage(channel: channel, controller: 123, value: 0).send();
  }

  /// Send CC Off on all controllers on a channel
  /// Maybe a silly approach and not recommended
  static void sendAllCCOffMessage(int channel) {
    for (int n = 0; n < 128; n++) {
      CCMessage(channel: channel, controller: n, value: 0).send();
    }
  }

  /// Brute Force Send Note Off on all notes on a channel
  /// Maybe a silly approach and not recommended
  static void sendAllNotesOffMessage(int channel) {
    for (int n = 0; n < 128; n++) {
      NoteOffMessage(channel: channel, note: n, velocity: 0).send();
    }
  }

  /// Sends a Sustain-pedal midi message
  static void sendSustainMessage(int channel, bool state) {
    CCMessage(channel: channel, controller: 64, value: state ? 127 : 0).send();
  }

  /// Sends a Mod Wheel midi message
  static void sendModWheelMessage(int channel, int value) {
    CCMessage(channel: channel, controller: 1, value: value.clamp(0, 127))
        .send();
  }

  /// Get note name String based on a midi value
  static String getNoteName(
    int value, {
    NoteSign sign = NoteSign.sharp,
    showOctaveIndex = true,
    showNoteValue = false,
    gmPercussionLabels = false,
  }) {
    if (value < 0 || value > 127) {
      return "#Range";
    }

    if (gmPercussionLabels) {
      return gm2PercStandard[value] ?? value.toString();
    }

    int octave = value ~/ 12;
    int note = value % 12;
    String octaveString = showOctaveIndex ? "${octave - 2}" : "";
    String noteString = showNoteValue ? " ($value)" : "";

    String output =
        "${sign == NoteSign.sharp ? midiNotesSharps[note] : midiNotesFlats[note]}$octaveString$noteString";

    return output;
  }

  /// Transpose generic scale interval pattern to absolute scale notes of the given root
  static List<int> absoluteScaleNotes(int root, List<int> scale) {
    return scale.map((e) => ((e + (root % 12))) % 12).toList();
  }

  /// Test if a given note is part of a specific scale
  static bool isNoteInScale(int note, List<int> scale, int root) {
    List<int> actualNotes = absoluteScaleNotes(root, scale);
    if (actualNotes.contains(note % 12)) {
      return true;
    }
    return false;
  }

  /// Get all notes that are part of a given scale between 0 - 127.
  static List<int> allAbsoluteScaleNotes(List<int> scale, int root) {
    List<int> actualNotes = absoluteScaleNotes(root, scale);

    List<int> list = [];
    for (int n = 0; n <= 127; n++) {
      if (actualNotes.contains(n % 12)) {
        list.add(n);
      }
    }
    return list;
  }

  /// Pass in a status Byte and return the expected message length
  static int lengthOfMessageType(int type) {
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

  /// Pass in a status Byte and return the Midi Message Type
  static MidiMessageType getMidiMessageType(int type) {
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
}
