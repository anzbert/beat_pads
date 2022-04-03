import 'package:beat_pads/services/pads_layouts.dart';
// import 'package:beat_pads/home/home.dart';
import 'package:beat_pads/services/services.dart';

abstract class PadUtils {
  static createGridList(Layout layout, int base, int width, int height,
      int root, List<int> scale) {
    List<int> grid = [];

    int semiTones;
    switch (layout) {
      case Layout.continuous:
        semiTones = width;
        break;
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
        return scaleOnlyGridList(root, scale, base, width * height);
    }

    for (int row = 0; row < height; row++) {
      for (int note = 0; note < width; note++) {
        grid.add(base + row * semiTones + note);
      }
    }
    return grid;
  }

  static List<List<int>> reversedRowLists(
    int root,
    int base,
    int width,
    int height,
    List<int> scale,
    Layout layout,
  ) {
    List<int> grid = createGridList(layout, base, width, height, root, scale);

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

    // generate grid:
    int octave = 0;
    int lastResult = 0;

    List<int> grid = List.generate(gridLength, (gridIndex) {
      int out = actualNotes[(gridIndex + baseOffset) % actualNotes.length] +
          base ~/ 12 * 12;

      if (out < lastResult) octave++;
      lastResult = out;

      return out + 12 * octave;
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
