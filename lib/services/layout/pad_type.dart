import 'package:beat_pads/services/constants/const_midi.dart';

enum PadType {
  encoder,
  note,
  chord;
}

class CustomPad {
  final int padValue;
  final PadType padType;
  final Chord chord;

  CustomPad(
    this.padValue, {
    this.padType = PadType.note,
    this.chord = Chord.major,
  });
}
