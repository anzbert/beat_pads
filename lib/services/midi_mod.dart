import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

abstract class Mod {
  /// Stores last sent value. Used to prevent unnecessary Midi messages
  num? lastSentValue;

  /// sends Modulation Midi Message
  ///
  /// input distance should always be:
  /// -1 to 0 to 1    OR    1 to 0 to 1
  void send(int channel, int note, double distance);
}

class ModPolyAfterTouch1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    int polyATChange = (distance.abs() * 127).toInt();
    if (polyATChange != lastSentValue) {
      PolyATMessage(channel: channel, note: note, pressure: polyATChange)
          .send();
      lastSentValue = polyATChange;
    }
  }
}
