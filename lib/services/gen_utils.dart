import 'package:flutter/foundation.dart';

/// Rotate a list by a given int value (positive = forward / negative = backwards)
List<T> rotateList<T>(List<T> list, int rotateBy) {
  if (list.isEmpty || rotateBy == 0) return list;
  int i = -rotateBy % list.length;
  return list.sublist(i)..addAll(list.sublist(0, i));
}

/// Create a range as <Iterable<int>>
Iterable<int> range(int start, int end) {
  return Iterable.generate(end - start, (i) => start + i++);
}

/// Print ONLY in debug mode
logd(dynamic text) {
  if (kDebugMode) print(text.toString());
}

/// Print array of values ONLY in debug mode
logdAll(List<dynamic> textList) {
  if (kDebugMode) {
    for (var text in textList) {
      print(text.toString());
    }
  }
}
