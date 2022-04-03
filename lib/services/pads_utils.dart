import 'package:beat_pads/services/_services.dart';

abstract class PadUtils {
  // Return a List of Notes, depending on the selected Layout
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

  /// Re-arrange a List to to a reversed list of rows (from the bottom up)
  /// This way it can be easily displayed using a Column of Rows.
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

  // Create a Grid, which onlyt contains Notes within a specific Scale
  static List<int> scaleOnlyGridList(
      int root, List<int> scale, int base, int gridLength) {
    List<int> actualNotes = MidiUtils.absoluteScaleNotes(root, scale);

    int validatedBase = base;
    while (!actualNotes.contains(validatedBase % 12)) {
      validatedBase = (validatedBase + 1) % 127;
    }

    int baseOffset = actualNotes.indexOf(
        validatedBase % 12); // check where grid will start within scale

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

  /// Create a grid layout based on the Magic Tone Network (TM)
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
