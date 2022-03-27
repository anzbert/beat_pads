import 'package:beat_pads/services/color_const.dart';
import 'package:flutter/material.dart';

var appTheme = ThemeData.dark().copyWith(
  primaryColor: Palette.cadetBlue.color,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Palette.cadetBlue.color,
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
);
