import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';

enum Palette {
  cadetBlue,
  yellowGreen,
  laserLemon,
  tan,
  lightPink,
  darkGrey,
  lightGrey,
  whiteLike;

  Color get color {
    switch (this) {
      case Palette.cadetBlue:
        return const HSLColor.fromAHSL(1, 212, 0.31, 0.69).toColor();
      case Palette.yellowGreen:
        return const HSLColor.fromAHSL(1, 90, .90, .84).toColor();
      case Palette.laserLemon:
        return const HSLColor.fromAHSL(1, 61, 1, .71).toColor();
      case Palette.tan:
        return const HSLColor.fromAHSL(1, 28, .59, .63).toColor();
      case Palette.lightPink:
        return const HSLColor.fromAHSL(1, 0, .95, .80).toColor();
      case Palette.darkGrey:
        return Colors.grey[800]!;
      case Palette.lightGrey:
        return const HSLColor.fromAHSL(1, 0, .0, .33).toColor();
      case Palette.whiteLike:
        return Colors.white70;
    }
  }
}

enum PadColors {
  colorWheel("In Pitch"),
  // halfColorWheel("In Pitch (Halfed Color Range)"),
  circleOfFifth("In Circle of Fifths"),
  highlightRoot("Just Highlight Root");

  final String title;
  const PadColors(this.title);

  static PadColors? fromName(String key) {
    for (PadColors mode in PadColors.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  Color colorize(
      Settings settings, int note, bool noteOn, int receivedVelocity) {
    final double hue;

    // out of midi range
    if (note > 127 || note < 0) return Palette.darkGrey.color;

    // received Midi
    if (receivedVelocity > 0) {
      return Palette.cadetBlue.color.withAlpha(receivedVelocity * 2);
    }

    // Color Schemes
    if (this == PadColors.colorWheel) {
      hue = (30 * ((note - settings.rootNote) % 12) + settings.baseHue) % 360;
    } else if (this == PadColors.circleOfFifth) {
      const circleOfFifth = [0, 7, 2, 9, 4, 11, 6, 1, 8, 3, 10, 5];
      hue = ((30 * circleOfFifth[(note - settings.rootNote) % 12]) +
              settings.baseHue) %
          360;
    } else {
      if (note % 12 == settings.rootNote) {
        hue = settings.baseHue.toDouble();
      } else {
        hue = (settings.baseHue + 210) % 360;
      }
    }

    final double alpha =
        MidiUtils.isNoteInScale(note, settings.scaleList, settings.rootNote)
            ? 1.0
            : 0.33;

    return HSLColor.fromAHSL(
      alpha,
      hue,
      .95,
      noteOn ? .60 : .80,
    ).toColor();
  }
}
