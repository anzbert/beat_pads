import 'dart:typed_data';

import 'package:beat_pads/services/constants/const_midi.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

enum MidiMessageType {
  unknown(-1), // variable length
  sysExStart(-1), // variable length

  noteOn(3),
  noteOff(3),
  cc(3),
  polyphonicAftertouch(3),
  pitchBend(3),
  positionPointer(3),

  programChange(2),
  aftertouch(2),
  midiTimeCode(2),
  songSelect(2),

  tuneRequest(1),
  sysExEnd(1),
  timingClock(1),
  start(1),
  cont(1),
  stop(1),
  activeSensing(1),
  systemReset(1);

  const MidiMessageType(this.byteLength);
  final int byteLength;

  /// Pass in a status Byte and return the Midi Message Type
  static MidiMessageType fromStatusByte(int type) {
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

    final int midiType = type & 0xF0;
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

abstract class MidiUtils {
  /// Kill all notes on a channel
  static void sendAllNotesOffMessage(int channel) {
    CCMessage(channel: channel, controller: 123, value: 0).send();
  }

  /// Sends a Sustain-pedal midi message
  static void sendSustainMessage(int channel, bool state) {
    CCMessage(channel: channel, controller: 64, value: state ? 127 : 0).send();
  }

  /// Sends a Frequency Cutoff / Slide (MPE) midi message. Takes a value from -1 to 1.
  static CCMessage slideMessage(
    int channel,
    double value, {
    bool initial64 = false,
  }) {
    final double finalValue =
        initial64 ? (value + 1) / 2 * 127 : value.abs() * 127;

    return CCMessage(
      channel: channel,
      controller: 74,
      value: finalValue.toInt(),
    );
  }

  /// Sends a Mod Wheel midi message. Takes a value from 0 - 127
  static void sendModWheelMessage(int channel, int value) {
    CCMessage(channel: channel, controller: 1, value: value.clamp(0, 127))
        .send();
  }

  /// Get note name String based on a midi value
  static String getNoteName(
    int value, {
    Sign sign = Sign.sharp,
    bool showOctaveIndex = true,
    bool showNoteValue = false,
    bool gmPercussionLabels = false,
  }) {
    if (value < 0 || value > 127) {
      return '#Range';
    }

    if (gmPercussionLabels) {
      return gm2PercStandard[value] ?? value.toString();
    }

    final int octave = value ~/ 12;
    final int note = value % 12;
    final String octaveString = showOctaveIndex ? '${octave - 2}' : '';
    final String noteString = showNoteValue ? ' ($value)' : '';

    final String output =
        '${sign == Sign.sharp ? midiNotesSharps[note] : midiNotesFlats[note]}$octaveString$noteString';

    return output;
  }

  /// Transpose generic scale interval pattern to absolute scale notes of the given root
  static List<int> absoluteScaleNotes(int root, List<int> scale) {
    return scale.map((e) => (e + (root % 12)) % 12).toList();
  }

  /// Test if a given note is part of a specific scale
  static bool isNoteInScale(int note, List<int> scale, int root) {
    final List<int> actualNotes = absoluteScaleNotes(root, scale);
    if (actualNotes.contains(note % 12)) {
      return true;
    }
    return false;
  }

  /// Get all notes that are part of a given scale between 0 - 127.
  static List<int> allAbsoluteScaleNotes(List<int> scale, int root) {
    final List<int> actualNotes = absoluteScaleNotes(root, scale);

    final List<int> list = [];
    for (int n = 0; n <= 127; n++) {
      if (actualNotes.contains(n % 12)) {
        list.add(n);
      }
    }
    return list;
  }

  /// Pass in a status Byte and return the expected message length
  static int lengthOfMessageByStatusByte(int type) {
    // sysex not included, as it is of variable length
    final List<int> commands1Bytes = [0xF6, 0xF8, 0xFA, 0xFB, 0xFC, 0xFF, 0xFE];
    final List<int> commands2Bytes = [0xF1, 0xF3];
    final List<int> commands3Bytes = [0xF2];
    if (commands1Bytes.contains(type)) return 1;
    if (commands2Bytes.contains(type)) return 2;
    if (commands3Bytes.contains(type)) return 3;

    final int midiType = type & 0xF0;
    final List<int> midi2Bytes = [0xC0, 0xD0];
    final List<int> midi3Bytes = [0x80, 0x90, 0xA0, 0xB0, 0xE0];
    if (midi2Bytes.contains(midiType)) return 2;
    if (midi3Bytes.contains(midiType)) return 3;

    return 0;
  }
}

class MPEinitMessage extends MidiMessage {
  /// ## Initialize MPE
  /// Uses lower zone by default, enable upperZone to switch.
  ///
  /// Set memberChannels to 0 to send turn zone off message.
  MPEinitMessage({this.memberChannels = 7, bool upperZone = false})
      : zone = upperZone ? 0x0F : 0x00;
  int zone;
  int memberChannels;

  @override
  void send() {
    data = Uint8List(12);
    // Reset all controllers:
    data[0] = 0xB0 + zone;
    data[1] = 0x79;
    data[2] = 0x00;

    // RPN 0x006
    data[3] = 0xB0 + zone;
    data[4] = 0x64;
    data[5] = 0x06;

    data[6] = 0xB0 + zone;
    data[7] = 0x65;
    data[8] = 0x00;

    // Channel Config
    data[9] = 0xB0 + zone;
    data[10] = 0x06;
    data[11] = memberChannels.clamp(0, 0x0F);

    super.send();
  }
}
