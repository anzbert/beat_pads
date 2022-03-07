import 'dart:typed_data';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class PitchBend extends MidiMessage {
  int channel = 0;
  double bend = 0.5;

  // static const int pitchCenter = 0x2000;
  // range 0-16384 (center 8192)  or   0 - 0x4000 (center 0x2000)

  PitchBend({this.channel = 0, this.bend = 0.5});

  @override
  void send() {
    int target = (bend * 0x4000).toInt();

    int bendMSB = target >> 7;
    int bendLSB = target & 0x7F; // Mask LSB 7bits 0b1111111

    data = Uint8List(3);
    data[0] = 0xE0 + channel;
    data[1] = bendLSB;
    data[2] = bendMSB;
    super.send();
  }
}
