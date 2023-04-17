import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Utils {
  static Future<bool> doNothingAsync() async => true;

  static Offset limitToSquare(Offset origin, Offset position, double radius) {
    var vectorX = -origin.dx + position.dx;
    var vectorY = -origin.dy + position.dy;

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
    final vectorX = -origin.dx + position.dx;
    final vectorY = -origin.dy + position.dy;

    final distance = Utils.offsetDistance(origin, position);

    if (distance > radius) {
      final unitVector = Offset(vectorX, vectorY) / distance;
      return unitVector * radius + origin;
    }

    return position;
  }

  /// Apply a curve to a positive *and* to a __negative__ value
  /// Input range is 0 to 1.0
  static double curveTransform(double input, Curve curve) {
    if (input.isNegative) {
      final temp = input.abs();
      return -curve.transform(temp.clamp(0, 1));
    }
    return curve.transform(input.clamp(0, 1));
  }

  /// Map input value from one range to another
  static double mapValueToTargetRange(
    double inputValue,
    double inputRangeStart,
    double inputRangeEnd,
    double outputRangeStart,
    double outputRangeEnd,
  ) {
    final inputRange = inputRangeEnd - inputRangeStart;
    final outputRange = outputRangeEnd - outputRangeStart;

    return (inputValue - inputRangeStart) * outputRange / inputRange +
        outputRangeStart;
  }

  /// Rotate a list by a given int value (positive = forward / negative = backwards)
  static List<T> rotateList<T>(List<T> list, int rotateBy) {
    if (list.isEmpty || rotateBy == 0) return list;
    final i = -rotateBy % list.length;
    return list.sublist(i)..addAll(list.sublist(0, i));
  }

  /// Create a range as <Iterable<int>>
  static Iterable<int> range(int start, int end) =>
      Iterable.generate(end - start, (i) => start + i++);

  /// get distance between 2 points
  static num distance(num x1, num y1, num x2, num y2) =>
      sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  /// get distance between 2 Offsets
  static double offsetDistance(Offset o1, Offset o2) =>
      sqrt(pow(o2.dx - o1.dx, 2) + pow(o2.dy - o1.dy, 2));

  /// get Offset of a Widget
  static Offset? getOffset(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final position = box?.localToGlobal(Offset.zero);
    return position;
  }

  /// get Size of a Widget
  static Size? getSize(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final size = box?.size;
    return size;
  }

  /// get the center Offset of a Widget
  static Offset? getCenterOffset(GlobalKey key) {
    final pos = getOffset(key);
    final size = getSize(key);
    if (pos == null || size == null) return null;

    final x = pos.dx + size.width / 2;
    final y = pos.dy + size.height / 2;
    return Offset(x, y);
  }

  /// Print ONLY in debug mode
  static void logd(String text) {
    if (kDebugMode) print(text);
  }

  /// Print array of values ONLY in debug mode
  static void logdAll(List<String> textList) {
    if (kDebugMode) {
      // ignore: avoid_print
      textList.forEach(print);
    }
  }
}
