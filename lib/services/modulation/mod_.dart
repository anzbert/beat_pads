import 'package:beat_pads/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

abstract class Mod {
  /// Stores last sent value. Used to prevent unnecessary Midi messages
  List<int> lastSentValues = [];

  /// input distance should always be: (-)1 to 0 to (-)1
  void send(double distance, int channel, int note);
}

class ModPitchBendToNote extends Mod {
  ModPitchBendToNote();

  /// Note is ignored in this Mod function
  @override
  void send(double distance, int channel, [int note = 0]) {
    final int pitchChange = (distance * 0x3FFF).toInt();

    if (!listEquals<num>([channel, pitchChange], lastSentValues)) {
      PitchBendMessage(
        channel: channel,
        bend: distance,
      ).send();

      lastSentValues = [channel, pitchChange];
    }
  }
}

class ModPitchBend extends Mod {
  ModPitchBend(this.pitchBendMax, this.range);
  final int pitchBendMax;
  final Range range;

  double dist(double input) {
    if (range == Range.up) return input.abs();
    if (range == Range.down) return -input.abs();
    return input;
  }

  /// note is ignored in this Mod function
  @override
  void send(double distance, int channel, int note) {
    final int pitchChange = (distance * 0x3FFF).toInt();

    if (!listEquals<num>([channel, pitchChange], lastSentValues)) {
      PitchBendMessage(
        channel: channel,
        bend: dist(distance) * pitchBendMax / 48,
      ).send();

      lastSentValues = [channel, pitchChange];
    }
  }
}

class ModPolyAfterTouch1D extends Mod {
  @override
  void send(double distance, int channel, int note) {
    final int polyATChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, note, polyATChange], lastSentValues)) {
      PolyATMessage(channel: channel, note: note, pressure: polyATChange)
          .send();

      lastSentValues = [channel, note, polyATChange];
    }
  }
}

class ModChannelAftertouch1D extends Mod {
  /// note is ignored in this Mod function
  @override
  void send(double distance, int channel, int note) {
    final int atChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, atChange], lastSentValues)) {
      ATMessage(channel: channel, pressure: atChange).send();
      lastSentValues = [channel, atChange];
    }
  }
}

class ModChannelAftertouch642D extends Mod {
  /// note is ignored in this Mod function
  @override
  void send(double distance, int channel, int note) {
    final int atChange = ((distance + 1) / 2 * 127).toInt();

    if (!listEquals<num>([channel, atChange], lastSentValues)) {
      ATMessage(channel: channel, pressure: atChange).send();
      lastSentValues = [channel, atChange];
    }
  }
}

class ModCC1D extends Mod {
  ModCC1D(this.cc);
  final CC cc;

  @override
  void send(double distance, int channel, int note) {
    final int ccChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, note, ccChange], lastSentValues)) {
      CCMessage(channel: channel, controller: cc.value, value: ccChange).send();
      lastSentValues = [channel, note, ccChange];
    }
  }
}

class ModCC642D extends Mod {
  ModCC642D(this.cc);
  final CC cc;

  @override
  void send(double distance, int channel, int note) {
    final int ccChange = ((distance + 1) / 2 * 127).toInt();

    if (!listEquals<num>([channel, note, ccChange], lastSentValues)) {
      CCMessage(channel: channel, controller: cc.value, value: ccChange).send();
      lastSentValues = [channel, note, ccChange];
    }
  }
}

class ModNull extends Mod {
  /// Blank function. Does nothing.
  @override
  void send(double distance, int channel, int note) {
    // Utils.logd('Sending debug placeholder: $channel / $note / $distance');
  }
}
