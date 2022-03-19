import 'midi_constants.dart';
export 'midi_constants.dart';

import 'package:beat_pads/components/drop_down_layout.dart';

/// Get Note Name String from Midi Value (0 - 127) as NoteSign.sharps (default) or NoteSign.flats
String getNoteName(
  int value, {
  NoteSign sign = NoteSign.sharp,
  showOctaveIndex = true,
  showNoteValue = false,
}) {
  if (value < 0 || value > 127) {
    return "Out of range";
  }

  int octave = value ~/ 12;
  int note = value % 12;
  String octaveString = showOctaveIndex ? "${octave - 2}" : "";
  String noteString = showNoteValue ? " ($value)" : "";

  if (sign == NoteSign.sharp) {
    return "${midiNotesSharps[note]}$octaveString$noteString";
  } else {
    return "${midiNotesFlats[note]}$octaveString$noteString";
  }
}

List<int> absoluteScaleNotes(int root, List<int> scale) {
  return scale.map((e) => ((e + (root % 12))) % 12).toList();
}

bool isNoteInScale(int note, List<int> scale, int root) {
  List<int> actualNotes = absoluteScaleNotes(root, scale);
  if (actualNotes.contains(note % 12)) {
    return true;
  }
  return false;
}

List<int> allAbsoluteScaleNotes(List<int> scale, int root) {
  List<int> actualNotes = absoluteScaleNotes(root, scale);

  List<int> list = [];
  for (int n = 0; n <= 127; n++) {
    if (actualNotes.contains(n % 12)) {
      list.add(n);
    }
  }
  return list;
}

List<int> scaleOnlyGrid(int root, List<int> scale, int base, int gridLength) {
  List<int> actualNotes = absoluteScaleNotes(root, scale);

  // print("base: ${base % 12}");
  // print("root: $root");
  // print("transp: $actualNotes");

  // ignore base values not in scale, add first higher one:
  int validatedBase = base;
  while (!actualNotes.contains(validatedBase % 12)) {
    validatedBase = (validatedBase + 1) % 127;
  }

  // check where grid will start in scale:
  int baseOffset = actualNotes.indexOf(validatedBase % 12);

  // print("offset: $baseOffset");

  List<int> grid = List.generate(gridLength, (gridIndex) {
    return validatedBase -
        actualNotes[baseOffset] +
        actualNotes[(baseOffset + gridIndex) % actualNotes.length] +
        (gridIndex ~/ actualNotes.length) * 12;
  });

  return grid;
}

createGrid(Layout layout, int base, int width, int height) {
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
