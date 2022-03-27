import 'package:beat_pads/services/color_const.dart';
import 'package:flutter/material.dart';

var appTheme = ThemeData.dark().copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Palette.cadetBlue.color),
    ),
  ),
);
