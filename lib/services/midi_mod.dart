import 'package:beat_pads/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

abstract class Mod {
  /// Stores last sent value. Used to prevent unnecessary Midi messages
  List<int> lastSentValues = [];

  /// sends Modulation Midi Message
  ///
  /// input distance should always be:
  /// -1 to 0 to 1    OR    1 to 0 to 1
  void send(int channel, int note, double distance);

  /// Resets value. Only if this method is implemented
  void reset() {
    Utils.logd("Reset not implemented for $this");
  }
}

class ModPolyAfterTouch1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    int polyATChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, note, polyATChange], lastSentValues)) {
      PolyATMessage(channel: channel, note: note, pressure: polyATChange)
          .send();

      lastSentValues = [channel, note, polyATChange];
    }
  }
}
