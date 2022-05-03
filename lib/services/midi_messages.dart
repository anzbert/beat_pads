import 'dart:typed_data';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MPEinitMessage extends MidiMessage {
  int zone;
  int memberChannels;

  /// ## Initialize MPE
  /// Uses lower zone by default, enable upperZone to switch.
  ///
  /// Set memberChannels to 0 to send turn zone off message.
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
