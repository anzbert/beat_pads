import 'package:flutter/material.dart';

import 'shared/_shared.dart';

var appTheme = ThemeData.dark().copyWith(
  primaryColor: Palette.cadetBlue.color,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Palette.cadetBlue.color,
      onPrimary: Palette.darkGrey.color,
      onSurface: Palette.cadetBlue.color,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Palette.cadetBlue.color,
    ),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: Palette.cadetBlue.color,
    thumbColor: Palette.cadetBlue.color,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Palette.yellowGreen.color;
      }
      if (states.contains(MaterialState.disabled)) {
        return Palette.darkGrey.color;
      }
      return Palette.cadetBlue.color;
    }),
    trackColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Palette.yellowGreen.color.withAlpha(150);
      }
      if (states.contains(MaterialState.disabled)) {
        return Palette.darkGrey.color;
      }
      return Palette.lightGrey.color;
    }),
  ),
);

abstract class ThemeConst {
  static double sliderWidthFactor = 0.85;
}
