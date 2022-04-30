import 'dart:typed_data';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MPEinitMessage extends MidiMessage {
  int zone;
  int memberChannels;

  /// ## Initialize MPE
  /// Uses lower zone by default, enable upperZone to switch.
  ///
  /// Set memberChannels to 0 to turn zone off.
  MPEinitMessage({this.memberChannels = 7, upperZone = false})
      : zone = upperZone ? 0x0F : 0x00;

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

class RPNMessage extends MidiMessage {
  int channel;
  int parameter;
  int value;

  /// ## RPN Message
  /// All defined RPN Parameters as per Midi Spec:
  /// - 0x0000 – Pitch bend range
  /// - 0x0001 – Fine tuning
  /// - 0x0002 – Coarse tuning
  /// - 0x0003 – Tuning program change
  /// - 0x0004 – Tuning bank select
  /// - 0x0005 – Modulation depth range
  ///
  /// Value Range is Hex: 0x0000 - 0x3FFFF or Decimal: 0-16383
  RPNMessage({this.channel = 0, this.parameter = 0, this.value = 0});

  @override
  void send() {
    data = Uint8List(12);
    // Data Entry MSB
    data[0] = 0xB0 + channel;
    data[1] = 0x65;
    data[2] = parameter >> 7;

    // Data Entry LSB
    data[3] = 0xB0 + channel;
    data[4] = 0x64;
    data[5] = parameter & 0x7F;

    // Data Value MSB
    data[6] = 0xB0 + channel;
    data[7] = 0x06;
    data[8] = value >> 7;

    // Data Value LSB
    data[9] = 0xB0 + channel;
    data[10] = 0x26;
    data[11] = value & 0x7F;

    super.send();
  }
}

/// RPN Message with data separated in MSB, LSB
class RPNHexMessage extends MidiMessage {
  int channel;
  int parameterMSB;
  int parameterLSB;
  int valueMSB;
  int valueLSB;

  RPNHexMessage({
    this.channel = 0,
    this.parameterMSB = 0,
    this.parameterLSB = 0,
    this.valueMSB = 0,
    this.valueLSB = -1,
  });

  @override
  void send() {
    var length = valueLSB > -1 ? 12 : 9;
    data = Uint8List(length);
    // Data Entry MSB
    data[0] = 0xB0 + channel;
    data[1] = 0x65;
    data[2] = parameterMSB;

    // Data Entry LSB
    data[3] = 0xB0 + channel;
    data[4] = 0x64;
    data[5] = parameterLSB;

    // Data Value MSB
    data[6] = 0xB0 + channel;
    data[7] = 0x06;
    data[8] = valueMSB;

    // Data Value LSB
    if (valueLSB > -1) {
      data[9] = 0xB0 + channel;
      data[10] = 0x26;
      data[11] = valueLSB;
    }

    super.send();
  }
}

/// It is best practice, but not mandatory, to send a Null Message at the end of a RPN
/// Stream to prevent accidental value changes on CC6 after a message has concluded.
class RPNNullMessage extends MidiMessage {
  int channel;

  RPNNullMessage({this.channel = 0});

  void send() {
    data = Uint8List(6);
    // Data Entry MSB
    data[0] = 0xB0 + channel;
    data[1] = 0x65;
    data[2] = 0x7F;

    // Data Entry LSB
    data[3] = 0xB0 + channel;
    data[4] = 0x64;
    data[5] = 0x7F;

    super.send();
  }
}
