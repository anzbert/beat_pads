import './midi_utils.dart';
import 'package:beat_pads/components/drop_down_layout.dart';

List<int> padNotesList(
  int rootNote,
  int baseNote,
  int width,
  int height,
  List<int> scale,
  bool scaleOnly,
  Layout layout,
) {
  List<int> grid = [];
  if (scaleOnly == true && layout == Layout.continuous) {
    grid = scaleOnlyGridList(rootNote, scale, baseNote, width * height);
  } else if (scaleOnly == false) {
    grid = createGridList(layout, baseNote, width, height);
  }

  if (grid.length != width * height) throw Exception("Pads: wrong grid size");
  return grid;
}

List<int> scaleOnlyGridList(
    int root, List<int> scale, int base, int gridLength) {
  List<int> actualNotes = absoluteScaleNotes(root, scale);

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

createGridList(Layout layout, int base, int width, int height) {
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
