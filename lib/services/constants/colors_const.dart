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
  baseRed,
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
        return const HSLColor.fromAHSL(1, 351, .77, .85).toColor();
      case Palette.darkGrey:
        return Colors.grey[800]!;
      case Palette.lightGrey:
        return const HSLColor.fromAHSL(1, 0, .0, .33).toColor();
      case Palette.whiteLike:
        return Colors.white70;
      case Palette.baseRed:
        return const HSLColor.fromAHSL(1, 0, .95, .80).toColor();
    }
  }
}

enum PadColors {
  colorWheel("Color Wheel"),
  circleOfFifth("Circle of Fifth"),
  highlightRoot("Highlight Root");

  final String title;
  const PadColors(this.title);

  static PadColors? fromName(String key) {
    for (PadColors mode in PadColors.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  Color colorize(int root, int note, List<int> scaleList, double hueShiftBase) {
    final double alpha =
        MidiUtils.isNoteInScale(note, scaleList, root) ? 1.0 : 0.33;

    final double hue;

    // Wheel
    if (this == PadColors.colorWheel) {
      hue = (30 * ((note - root) % 12) + hueShiftBase) % 360;
    }
    // CoF
    else if (this == PadColors.circleOfFifth) {
      const circleOfFifth = [0, 7, 2, 9, 4, 11, 6, 1, 8, 3, 10, 5];
      hue = ((30 * circleOfFifth[(note - root) % 12]) + hueShiftBase) % 360;
    }
    // Default
    else {
      if (note % 12 == root) {
        hue = hueShiftBase;
      } else {
        hue = (hueShiftBase + 210) % 360;
      }
    }

    return HSLColor.fromColor(Palette.baseRed.color)
        .withHue(hue)
        .withAlpha(alpha)
        .toColor();
  }
}
