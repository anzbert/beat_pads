import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:flutter/material.dart';

abstract class Utils {
// UTILITY

  static debugLog(String label, dynamic value, int seconds) async {
    while (true) {
      await Future.delayed(Duration(seconds: seconds), () {
        Utils.logd("$label: $value");
      });
    }
  }

  static Offset limitToSquare(Offset origin, Offset position, double radius) {
    double vectorX = -origin.dx + position.dx;
    double vectorY = -origin.dy + position.dy;

    if (vectorX.abs() > radius) {
      if (vectorX.isNegative) vectorX = -radius;
      if (!vectorX.isNegative) vectorX = radius;
    }
    if (vectorY.abs() > radius) {
      if (vectorY.isNegative) vectorY = -radius;
      if (!vectorY.isNegative) vectorY = radius;
    }
    return Offset(vectorX, vectorY) + origin;
  }

  static Offset limitToCircle(Offset origin, Offset position, double radius) {
    double vectorX = -origin.dx + position.dx;
    double vectorY = -origin.dy + position.dy;

    double distance = Utils.offsetDistance(origin, position);

    if (distance > radius) {
      Offset unitVector = Offset(vectorX, vectorY) / distance;
      return unitVector * radius + origin;
    }

    return position;
  }

  /// Apply a curve to a positive *and* to a __negative__ value
  /// Input range is 0 to 1.0
  static double curveTransform(double input, Curve curve) {
    if (input.isNegative) {
      double temp = input.abs();
      return -curve.transform(temp.clamp(0, 1));
    }
    return curve.transform(input.clamp(0, 1));
  }

  /// Map input value from one range to another
  static double mapValueToTargetRange(double inputValue, double inputRangeStart,
      double inputRangeEnd, double outputRangeStart, double outputRangeEnd) {
    double inputRange = inputRangeEnd - inputRangeStart;
    double outputRange = outputRangeEnd - outputRangeStart;

    return (inputValue - inputRangeStart) * outputRange / inputRange +
        outputRangeStart;
  }

  /// Rotate a list by a given int value (positive = forward / negative = backwards)
  static List<T> rotateList<T>(List<T> list, int rotateBy) {
    if (list.isEmpty || rotateBy == 0) return list;
    int i = -rotateBy % list.length;
    return list.sublist(i)..addAll(list.sublist(0, i));
  }

  /// Create a range as <Iterable<int>>
  static Iterable<int> range(int start, int end) {
    return Iterable.generate(end - start, (i) => start + i++);
  }

  /// get distance between 2 points
  static num distance(num x1, num y1, num x2, num y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  /// get distance between 2 Offsets
  static double offsetDistance(Offset o1, Offset o2) {
    return sqrt(pow(o2.dx - o1.dx, 2) + pow(o2.dy - o1.dy, 2));
  }

  /// get Offset of a Widget
  static Offset? getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);
    return position;
  }

  /// get Size of a Widget
  static Size? getSize(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Size? size = box?.size;
    return size;
  }

  /// get the center Offset of a Widget
  static Offset? getCenterOffset(GlobalKey key) {
    var pos = getOffset(key);
    var size = getSize(key);
    if (pos == null || size == null) return null;

    var x = pos.dx + size.width / 2;
    var y = pos.dy + size.height / 2;
    return Offset(x, y);
  }

  /// Print ONLY in debug mode
  static logd(dynamic text) {
    if (kDebugMode) print(text.toString());
  }

  /// Print array of values ONLY in debug mode
  static logdAll(List<dynamic> textList) {
    if (kDebugMode) {
      for (var text in textList) {
        print(text.toString());
      }
    }
  }
}
