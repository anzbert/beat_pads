import 'package:beat_pads/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class ModPolyAfterTouch1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    final polyATChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, note, polyATChange], lastSentValues)) {
      PolyATMessage(channel: channel, note: note, pressure: polyATChange)
          .send();

      lastSentValues = [channel, note, polyATChange];
    }
  }
}
