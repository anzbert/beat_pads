import 'package:flutter_midi_command/flutter_midi_command.dart';

class Vector2D {
  const Vector2D(this.x, this.y);

  final int x;
  final int y;

  int get area {
    return x * y;
  }

  List<int> toList() {
    return [x, y];
  }
}

// class MidiTriplet {
//   int channel;
//   int parameter;
//   int value;

//   // 3 Byte Midi-Data
//   MidiTriplet(this.channel, this.parameter, [this.value = 0]);
// }
