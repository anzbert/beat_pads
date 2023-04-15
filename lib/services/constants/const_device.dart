// Sizes from https://docs.flutter.dev/development/ui/layout/building-adaptive-apps
// and https://www.ios-resolution.com/
// get real world dimensions: https://www.omnicalculator.com/other/screen-size

import 'package:flutter/material.dart';

enum ScreenSize {
  small(8),
  normal(10),
  large(12);

  const ScreenSize(this.maxGrid);
  final int maxGrid;

  static ScreenSize getSizeEnum(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.shortestSide;
    if (deviceWidth > 900) return ScreenSize.large;
    if (deviceWidth > 600) return ScreenSize.normal;
    return ScreenSize.small;
  }
}
