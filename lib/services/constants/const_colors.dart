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
