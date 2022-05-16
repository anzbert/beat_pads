// Sizes from https://docs.flutter.dev/development/ui/layout/building-adaptive-apps

import 'package:flutter/material.dart';

enum ScreenSize {
  small(8),
  normal(12),
  large(16);

  final int maxGrid;
  const ScreenSize(this.maxGrid);

  static ScreenSize getSize(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.shortestSide;
    if (deviceWidth > 800) return ScreenSize.large;
    if (deviceWidth > 550) return ScreenSize.normal;
    return ScreenSize.small;
  }
}
