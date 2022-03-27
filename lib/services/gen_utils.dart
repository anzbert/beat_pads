import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:flutter/material.dart';

abstract class Utils {
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

  static double offsetDistance(Offset o1, Offset o2) {
    return sqrt(pow(o2.dx - o1.dx, 2) + pow(o2.dy - o1.dy, 2));
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
