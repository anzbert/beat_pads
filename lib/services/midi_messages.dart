import 'dart:typed_data';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

// static const int pitchCenter = 0x2000;
// range 0-16384 (center 8192)  or   0 - 0x4000 (center 0x2000)

class PitchBendMessage extends MidiMessage {
  final int channel;
  final double bend;

  /// Create Pitch Bend Message with a bend value range of 0.0 to 1.0 (default: 0.5).
  PitchBendMessage({this.channel = 0, this.bend = 0.5});

  @override
  void send() {
    double targetRange = bend.clamp(0, 1) * 0x4000;
    int targetValue = targetRange.toInt();

    int bendMSB = targetValue >> 7;
    int bendLSB = targetValue & 0x7F; // Mask LSB 7bits 0b1111111

    data = Uint8List(3);
    data[0] = 0xE0 + channel;
    data[1] = bendLSB;
    data[2] = bendMSB;
    super.send();
  }
}

class PPAftertouchMessage extends MidiMessage {
  int channel = 0;
  int note = 0;
  int pressure = 0;

  /// Create a Polyphonic Aftertouch Message for a single note
  PPAftertouchMessage({this.channel = 0, this.note = 0, this.pressure = 0});

  @override
  void send() {
    data = Uint8List(3);
    data[0] = 0xA0 + channel;
    data[1] = note;
    data[2] = pressure;
    super.send();
  }
}

class AftertouchMessage extends MidiMessage {
  int channel = 0;
  int pressure = 0;

  /// Create an Aftertouch Message for a single channel
  AftertouchMessage({this.channel = 0, this.pressure = 0});

  @override
  void send() {
    data = Uint8List(2);
    data[0] = 0xD0 + channel;
    data[1] = pressure;
    super.send();
  }
}
