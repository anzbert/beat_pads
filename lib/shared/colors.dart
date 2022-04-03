import 'package:flutter/material.dart';

/// Custom Palette for this App
enum Palette {
  cadetBlue,
  yellowGreen,
  laserLemon,
  tan,
  lightPink,
  darkGrey,
  lightGrey,
  whiteLike,
}

extension RGB on Palette {
  Color get color {
    switch (this) {
      case Palette.cadetBlue:
        return HSLColor.fromAHSL(1, 212, 0.31, 0.69).toColor();
      case Palette.yellowGreen:
        return HSLColor.fromAHSL(1, 89, 1, .84).toColor();
      case Palette.laserLemon:
        return HSLColor.fromAHSL(1, 61, 1, .71).toColor();
      case Palette.tan:
        return HSLColor.fromAHSL(1, 28, .59, .63).toColor();
      case Palette.lightPink:
        return HSLColor.fromAHSL(1, 351, .77, .82).toColor();
      case Palette.darkGrey:
        return Colors.grey[800]!;
      case Palette.lightGrey:
        return Colors.grey;
      case Palette.whiteLike:
        return Colors.white70;
    }
  }
}

// Color _temp = HSLColor.fromAHSL(1, 351, .77, .82).toColor();

/* CSS HSL */
// --cadet-blue-crayola: hsla(212, 31%, 69%, 1); 
// --yellow-green-crayola: hsla(89, 100%, 84%, 1); 
// --laser-lemon: hsla(61, 100%, 71%, 1); 
// --tan-crayola: hsla(28, 59%, 63%, 1); 
// --light-pink: hsla(351, 77%, 82%, 1);


// RGB
// --cadet-blue-crayola: #96adc8ff;
// --yellow-green-crayola: #d7ffabff;
// --laser-lemon: #fcff6cff;
// --tan-crayola: #d89d6aff;
// --light-pink: #f4acb7ff;