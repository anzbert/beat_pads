import 'package:beat_pads/services/services.dart';

enum PadType {
  encoder,
  note,
  chord;
}

class CustomPad {
  CustomPad(
    this.padValue, {
    this.row = 0,
    this.pitchBendLeft = 1,
    this.pitchBendRight = 1,
    this.padType = PadType.note,
    this.chord = Chord.major,
  });
  final int padValue;
  final PadType padType;
  final Chord chord;
  int row;

  /// Semitones to pitchbend in [PlayMode.mpeTargetPb] left and right
  /// on the current pad. Default is 1 semitone.
  final int pitchBendLeft;
  final int pitchBendRight;
}
