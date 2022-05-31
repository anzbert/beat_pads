import 'package:flutter/material.dart';

import './services/services.dart';

var appTheme = ThemeData.dark().copyWith(
  dividerTheme: DividerThemeData(
    thickness: 1,
    color: Palette.lightGrey,
  ),
  primaryColor: Palette.cadetBlue,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 6,
      primary: Palette.cadetBlue,
      onPrimary: Palette.darkGrey,
      onSurface: Palette.cadetBlue,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Palette.cadetBlue,
    ),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: Palette.cadetBlue,
    thumbColor: Palette.cadetBlue,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Palette.darker(Palette.yellowGreen, 0.9);
      }
      if (states.contains(MaterialState.disabled)) {
        return Palette.darkGrey;
      }
      return Palette.cadetBlue;
    }),
    trackColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Palette.yellowGreen;
      }
      if (states.contains(MaterialState.disabled)) {
        return Palette.darkGrey;
      }
      return Palette.lightGrey;
    }),
  ),
  // textTheme: TextTheme(
  //   bodyText1: TextStyle(),
  //   bodyText2: TextStyle(),
  // ).apply(
  //   bodyColor: Colors.orange,
  //   displayColor: Colors.blue,
  // ),
);

abstract class ThemeConst {
  static double sliderWidthFactor = 0.8;
  static double padSpacingFactor = 0.003;
  static double padRadiusFactor = 0.006;
  static double borderFactor = 0.006;
}
