// import 'package:flutter_test/flutter_test.dart';
// import 'package:beat_pads/services/midi_utils.dart';

// import 'package:flutter/foundation.dart';

// void main() {
//   group("pad creation tests", () {
//     int width = 2;
//     int height = 2;

//     List<int> scale = [0, 2, 4, 6, 8, 10];
//     int rootNote = 0;
//     int baseNote = 36;

//     test("Create a pad grid of scale-only values", () {
//       // Layout.continuous

//       var a = getFilledPadsArray(scale, baseNote, rootNote, width * height);
//       var b = [36, 38, 40, 42];
//       expect(listEquals(a, b), true);
//     });
//     test("2", () {
//       rootNote = 1;
//       var a = getFilledPadsArray(scale, baseNote, rootNote, width * height);
//       var b = [37, 39, 41, 43];
//       expect(listEquals(a, b), true);
//     });
//     test("3", () {
//       baseNote = 37;
//       var a = getFilledPadsArray(scale, baseNote, rootNote, width * height);
//       var b = [38, 40, 42, 44];
//       expect(listEquals(a, b), true);
//     });
//   });
// }
