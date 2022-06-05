import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

abstract class Palette {
  static Color cadetBlue =
      const HSLColor.fromAHSL(1, 212, 0.31, 0.69).toColor();
  static Color yellowGreen = const HSLColor.fromAHSL(1, 90, .90, .84).toColor();
  static Color laserLemon = const HSLColor.fromAHSL(1, 61, 1, .71).toColor();
  static Color tan = const HSLColor.fromAHSL(1, 28, .59, .63).toColor();
  static Color lightPink = const HSLColor.fromAHSL(1, 0, .95, .80).toColor();
  static Color darkPink = const HSLColor.fromAHSL(1, 0, .15, .50).toColor();
  static Color darkGrey = const Color.fromARGB(255, 66, 66, 66);
  static Color lightGrey = const HSLColor.fromAHSL(1, 0, .0, .33).toColor();
  static Color whiteLike = const Color.fromRGBO(255, 255, 255, 0.702);
  static Color splashColor = Palette.whiteLike;
  static Color dirtyTranslucent =
      const HSLColor.fromAHSL(0.2, 0, .0, .33).toColor();

  static Color darker(Color color, double factor) {
    HSLColor hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness(hsl.lightness * factor)
        .withSaturation(hsl.saturation * (factor * 0.33))
        .toColor();
  }
}

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
