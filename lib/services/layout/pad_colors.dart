import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

enum PadColors {
  highlightRoot('Highlight Root'),
  colorWheel('Pitch'),
  // halfColorWheel("In Pitch (Halfed Color Range)"),
  circleOfFifth('Circle of Fifths');

  const PadColors(this.title);

  final String title;

  @override
  String toString() => title;

  Color colorize(
    List<int> scaleList,
    int baseHue,
    int rootNote,
    int note,
    int receivedVelocity, {
    required bool noteOn,
  }) {
    final double hue;

    // note on
    // if (noteOn) return Palette.whiteLike;

    // out of midi range
    if (note > 127 || note < 0) return Palette.darkGrey;

    // received Midi
    if (receivedVelocity > 0) {
      return Palette.whiteLike.withAlpha(receivedVelocity * 2);
    }

    // Color Schemes
    if (this == PadColors.colorWheel) {
      hue = (30 * ((note - rootNote) % 12) + baseHue) % 360;
    } else if (this == PadColors.circleOfFifth) {
      const circleOfFifth = [0, 7, 2, 9, 4, 11, 6, 1, 8, 3, 10, 5];
      hue = ((30 * circleOfFifth[(note - rootNote) % 12]) + baseHue) % 360;
    } else {
      if (note % 12 == rootNote) {
        hue = baseHue.toDouble();
      } else {
        hue = (baseHue + 210) % 360;
      }
    }

    final color = HSLColor.fromAHSL(
      1,
      hue,
      .95,
      .80,
    ).toColor();

    if (noteOn) {
      return MidiUtils.isNoteInScale(note, scaleList, rootNote)
          ? Palette.desaturate(color, 0.58)
          : Palette.lighten(Palette.darkishGrey, 0.18);
    } else {
      return MidiUtils.isNoteInScale(note, scaleList, rootNote)
          ? color
          : Palette.darkishGrey;
    }
  }
}
