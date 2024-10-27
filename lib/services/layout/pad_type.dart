import 'package:beat_pads/services/services.dart';

enum PadType {
  encoder,
  note,
  chord;
}

class CustomPad {
  CustomPad(
    this.padValue, {
    this.pitchBendLeft = 1,
    this.pitchBendRight = 1,
    this.padType = PadType.note,
    this.chord = Chord.major,
  });

  /// Padvalue is the Midi Pitch
  final int padValue;

  /// Only type currently supported is Notes
  final PadType padType;

  /// Chords not yet supported
  final Chord chord;

  int row = 0;
  int column = 0;

  /// Creates a unique pad ID
  int get id => row * 100 + column;

  /// Semitones to pitchbend in [PlayMode.mpeTargetPb] left and right
  /// on the current pad. Default is 1 semitone.
  final int pitchBendLeft;
  final int pitchBendRight;
}
