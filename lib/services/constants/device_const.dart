// Sizes from https://docs.flutter.dev/development/ui/layout/building-adaptive-apps

import 'package:flutter/material.dart';

enum ScreenSize {
  small,
  normal,
  large,
  extraLarge;

  static ScreenSize getSize(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.shortestSide;
    if (deviceWidth > 900) return ScreenSize.extraLarge;
    if (deviceWidth > 600) return ScreenSize.large;
    if (deviceWidth > 300) return ScreenSize.normal;
    return ScreenSize.small;
  }
}
