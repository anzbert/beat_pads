import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';

abstract class ThemeConst {
  static const double sliderWidthFactor = 0.8;
  static const double padSpacingFactor = 0.003;
  static const double padRadiusFactor = 0.006;
  static const double borderFactor = 0.006;
  static const double menuButtonMinWidth = 300;
  static const double listViewBottomPadding = 100;
}

var appTheme = ThemeData.dark().copyWith(
  useMaterial3: true,
  dividerTheme: DividerThemeData(
    thickness: 1,
    color: Palette.lightGrey,
  ),
  primaryColor: Palette.cadetBlue,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      foregroundColor: Palette.darkGrey,
      backgroundColor: Palette.cadetBlue,
      elevation: 6,
      disabledForegroundColor: Palette.cadetBlue.withOpacity(0.38),
      disabledBackgroundColor: Palette.cadetBlue.withOpacity(0.12),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Palette.cadetBlue,
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
);
