import 'package:beat_pads/services/constants/const_midi.dart';

enum PadType {
  encoder,
  note,
  chord;
}

class CustomPad {
  CustomPad(
    this.padValue, {
    this.padType = PadType.note,
    this.chord = Chord.major,
  });
  final int padValue;
  final PadType padType;
  final Chord chord;
}
