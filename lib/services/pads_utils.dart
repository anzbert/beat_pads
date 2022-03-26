import 'package:beat_pads/services/pads_layouts.dart';

import './midi_utils.dart';

abstract class PadUtils {
  static createGridList(Layout layout, int base, int width, int height,
      int rootNote, List<int> scale, int baseNote) {
    List<int> grid = [];

    int semiTones;
    switch (layout) {
      case Layout.minorThird:
        semiTones = 3;
        break;
      case Layout.majorThird:
        semiTones = 4;
        break;
      case Layout.quart:
        semiTones = 5;
        break;
      case Layout.toneNetwork:
        return createToneNetworkList(base, width, height);
      case Layout.xPressPadsStandard:
        return xPressPadsStandard;
      case Layout.scaleNotesOnly:
        return scaleOnlyGridList(rootNote, scale, baseNote, width * height);
      default:
        semiTones = width;
        break;
    }

    for (int row = 0; row < height; row++) {
      for (int note = 0; note < width; note++) {
        grid.add(base + row * semiTones + note);
      }
    }
    return grid;
  }

  static List<List<int>> reversedRowLists(
    int rootNote,
    int baseNote,
    int width,
    int height,
    List<int> scale,
    Layout layout,
  ) {
    List<int> grid = createGridList(
        layout, baseNote, width, height, rootNote, scale, baseNote);

    return List.generate(
      height,
      (row) => List.generate(width, (note) {
        return grid[row * width + note];
      }),
    ).reversed.toList();
  }

  static List<int> scaleOnlyGridList(
      int root, List<int> scale, int base, int gridLength) {
    List<int> actualNotes = MidiUtils.absoluteScaleNotes(root, scale);

    // ignore base values not in scale, add first higher one:
    int validatedBase = base;
    while (!actualNotes.contains(validatedBase % 12)) {
      validatedBase = (validatedBase + 1) % 127;
    }

    // check where grid will start in scale:
    int baseOffset = actualNotes.indexOf(validatedBase % 12);

    List<int> grid = List.generate(gridLength, (gridIndex) {
      return validatedBase -
          actualNotes[baseOffset] +
          actualNotes[(baseOffset + gridIndex) % actualNotes.length] +
          (gridIndex ~/ actualNotes.length) * 12;
    });

    return grid;
  }

  static List<int> createToneNetworkList(int base, int width, int height) {
    List<int> grid = [];

    for (int row = 0; row < height; row++) {
      for (int note = 0; note < width; note++) {
        grid.add(note * 7 + row * 4 + base);
      }
    }
    return grid;
  }
}
