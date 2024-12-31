import 'package:flutter/material.dart';

abstract class Palette {
  // solid colors:
  static Color cadetBlue =
      const HSLColor.fromAHSL(1, 212, 0.31, 0.69).toColor();
  static Color yellowGreen = const HSLColor.fromAHSL(1, 90, .90, .84).toColor();
  static Color laserLemon = const HSLColor.fromAHSL(1, 61, 1, .71).toColor();
  static Color tan = const HSLColor.fromAHSL(1, 28, .59, .63).toColor();
  static Color lightPink = const HSLColor.fromAHSL(1, 0, .95, .80).toColor();
  static Color darkPink = const HSLColor.fromAHSL(1, 0, .15, .50).toColor();
  static Color lightGrey = const HSLColor.fromAHSL(1, 0, 0, .33).toColor();
  static Color darkGrey = const Color.fromARGB(255, 66, 66, 66);
  static Color menuHeaders = const Color.fromARGB(255, 45, 43, 54);
  static Color darkishGrey = const Color.fromARGB(255, 85, 85, 85);
  static Color whiteLike = const Color.fromRGBO(240, 240, 240, 1);
  static Color splashColor = Palette.whiteLike;

  // colors with alpha:
  static Color dirtyTranslucent =
      const HSLColor.fromAHSL(0.2, 0, 0, .33).toColor();

  // methods:

  static Color darker(Color color, double factor) {
    final HSLColor hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness(hsl.lightness * factor)
        .withSaturation(hsl.saturation * (factor * 0.33))
        .toColor();
  }

  /// ranges from 0.0 to 1.0
  static Color desaturate(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'Color desat assert failed');

    final hsl = HSLColor.fromColor(color);
    final hslDark =
        hsl.withSaturation((hsl.saturation - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// ranges from 0.0 to 1.0
  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'Color lighten assert failed');

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
