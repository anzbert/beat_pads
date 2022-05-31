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
  static Color splashColor = const HSLColor.fromAHSL(1, 0, .0, .35).toColor();
  static Color whiteLike = const Color.fromRGBO(255, 255, 255, 0.702);
  static Color dirtyTranslucent =
      const HSLColor.fromAHSL(0.2, 0, .0, .33).toColor();

  static Color darker(Color color, double factor) {
    HSLColor hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness(hsl.lightness * factor)
        .withSaturation(hsl.saturation * factor)
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
    Settings settings,
    int note,
    bool noteOn,
    int receivedVelocity,
  ) {
    final double hue;

    // out of midi range
    if (note > 127 || note < 0) return Palette.darkGrey;

    // received Midi
    if (receivedVelocity > 0) {
      return Palette.cadetBlue.withAlpha(receivedVelocity * 2);
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

    if (noteOn) return Palette.lightGrey;

    return HSLColor.fromAHSL(
      alpha,
      hue,
      .95,
      .80,
    ).toColor();
  }
}
