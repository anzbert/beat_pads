import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

enum PadColors {
  colorWheel("Pitch"),
  // halfColorWheel("In Pitch (Halfed Color Range)"),
  circleOfFifth("Circle of Fifths"),
  highlightRoot("Highlight Root");

  final String title;
  const PadColors(this.title);

  static PadColors? fromName(String key) {
    for (PadColors mode in PadColors.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  @override
  String toString() => title;

  Color colorize(
    List<int> scaleList,
    int baseHue,
    int rootNote,
    int note,
    bool noteOn,
    int receivedVelocity,
  ) {
    final double hue;

    // note on
    if (noteOn) return Palette.whiteLike;

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

    return MidiUtils.isNoteInScale(note, scaleList, rootNote)
        ? color
        : Palette.darker(Palette.lightGrey, 1);
  }
}
