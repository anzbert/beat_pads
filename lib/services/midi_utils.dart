import 'midi_const.dart';
export 'midi_const.dart';

abstract class MidiUtils {
  /// Get note name based on midi value
  static String getNoteName(
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

  /// Transpose generic scale interval pattern to absolute scale notes of the given root
  static List<int> absoluteScaleNotes(int root, List<int> scale) {
    return scale.map((e) => ((e + (root % 12))) % 12).toList();
  }

  /// Test if a given note is part of a specific scale
  static bool isNoteInScale(int note, List<int> scale, int root) {
    List<int> actualNotes = absoluteScaleNotes(root, scale);
    if (actualNotes.contains(note % 12)) {
      return true;
    }
    return false;
  }

  /// Get all notes that are part of a given scale between 0 - 127.
  static List<int> allAbsoluteScaleNotes(List<int> scale, int root) {
    List<int> actualNotes = absoluteScaleNotes(root, scale);

    List<int> list = [];
    for (int n = 0; n <= 127; n++) {
      if (actualNotes.contains(n % 12)) {
        list.add(n);
      }
    }
    return list;
  }
}
