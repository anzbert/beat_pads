import 'package:beat_pads/services/services.dart';

enum Layout {
  // majorThird('Chromatic - Vertical Maj 3rd', chromatic: true),
  // quart('Chromatic - Vertical 4th', chromatic: true),
  // quint('Chromatic - Vertical 5th', chromatic: true),
  customIntervals('Chromatic', custom: true, chromatic: true),
  scaleNotesCustom('In Key', custom: true),
  sequential('Chromatic - Sequential', chromatic: true),
  // scaleNotes3rd('In Key - Vertical 2 Scale Steps'),
  // scaleNotes4th('In Key - Vertical 3 Scale Steps'),
  // scaleNotes5th('In Key - Vertical 4 Scale Steps'),
  scaleNotesOnly('In Key - Sequential'),
  progrChange('Program Changes', chromatic: true),
  magicToneNetwork('Magic Tone Network™', defaultDimensions: Vector2Int(8, 8)),
  xPressPadsStandard('XpressPads™ Standard 4x4',
      resizable: false,
      defaultDimensions: Vector2Int(4, 4),
      gmPercussionLabels: true),
  xPressPadsLatinJazz('XpressPads™ Latin/Jazz 4x4',
      resizable: false,
      defaultDimensions: Vector2Int(4, 4),
      gmPercussionLabels: true),
  xPressPadsXO('XpressPads™ with XO 4x4',
      resizable: false, defaultDimensions: Vector2Int(4, 4)),
  xPressPadsXtreme('XpressPads™ Xtreme 8x4',
      resizable: false,
      defaultDimensions: Vector2Int(8, 4),
      gmPercussionLabels: true),
  ;

  const Layout(
    this.title, {
    this.custom = false,
    this.resizable = true,
    this.chromatic = false,
    this.gmPercussionLabels = false,
    this.defaultDimensions,
  });

  final String title;
  final bool custom;
  final bool resizable;
  final bool gmPercussionLabels;
  final Vector2Int? defaultDimensions;
  final bool chromatic;

  @override
  String toString() => title;

  Grid getGrid(int width, int height, int rootNote, int baseNote,
      List<int> scaleList, int customIntervalX, int customIntervalY) {
    final GridData settings = GridData(width, height, rootNote, baseNote,
        scaleList, customIntervalX, customIntervalY);

    switch (this) {
      // case Layout.majorThird:
      //   return GridChromaticByRowInterval(settings, rowInterval: 4);
      // case Layout.quart:
      //   return GridChromaticByRowInterval(settings, rowInterval: 5);
      // case Layout.quint:
      //   return GridChromaticByRowInterval(settings, rowInterval: 7);
      case Layout.customIntervals:
        return GridChromaticByCustomIntervals(settings);
      case Layout.sequential:
        return GridChromaticByRowInterval(settings, rowInterval: width);

      // case Layout.scaleNotes3rd:
      //   return GridInScaleCustom(settings, fixedXY: const Vector2Int(1, 2));
      // case Layout.scaleNotes4th:
      //   return GridInScaleCustom(settings, fixedXY: const Vector2Int(1, 3));
      // case Layout.scaleNotes5th:
      //   return GridInScaleCustom(settings, fixedXY: const Vector2Int(1, 4));
      case Layout.scaleNotesCustom:
        return GridInScaleCustom(settings);
      case Layout.scaleNotesOnly:
        return GridInScaleCustom(settings,
            fixedXY: Vector2Int(1, settings.width));

      case Layout.magicToneNetwork:
        return GridMTN(settings);
      case Layout.xPressPadsStandard:
        return GridXpressPads(settings, XPP.standard);
      case Layout.xPressPadsLatinJazz:
        return GridXpressPads(settings, XPP.latinJazz);
      case Layout.xPressPadsXO:
        return GridXpressPads(settings, XPP.xo);
      case Layout.xPressPadsXtreme:
        return GridXpressPads(settings, XPP.xtreme);
      case Layout.progrChange:
        return GridChromaticByRowInterval(settings, rowInterval: width);
    }
  }
}

/// Holds all the settings required to build any Grid
class GridData {
  GridData(this.width, this.height, this.rootNote, this.baseNote,
      this.scaleList, this.customIntervalX, this.customIntervalY);
  final int width;
  final int height;
  final int rootNote;
  final int baseNote;
  final List<int> scaleList;
  final int customIntervalX;
  final int customIntervalY;
}

/// Base class that converts a List into the required rows
/// Classes derived from this one need to implement a function that
/// creates a list of notes
abstract class Grid {
  /// Creates a Pad Grid generating class using the current settings
  Grid(this.settings);

  final GridData settings;

  /// Get a List of all notes in the current grid
  List<CustomPad> get list;

  /// Convert List to Rows of all notes in the grid, starting from the top Row
  /// Useful for building the grid with a Column Widget
  List<List<CustomPad>> get rows {
    if (settings.height * settings.width != list.length) return [[]];

    return List.generate(
      settings.height,
      (row) => List.generate(settings.width, (note) {
        return list[row * settings.width + note]
          ..row = row
          ..column = note;
      }),
    ).reversed.toList();
  }
}

/// A chromatic Grid with variable intervals between rows
class GridChromaticByRowInterval extends Grid {
  GridChromaticByRowInterval(super.settings, {required this.rowInterval});

  final int rowInterval;

  @override
  List<CustomPad> get list {
    final List<CustomPad> grid = [];
    for (int row = 0; row < settings.height; row++) {
      for (int note = 0; note < settings.width; note++) {
        grid.add(CustomPad(settings.baseNote + row * rowInterval + note));
      }
    }
    return grid;
  }
}

/// Grid that has custom set semitone intervals on the x and y axis
class GridChromaticByCustomIntervals extends Grid {
  GridChromaticByCustomIntervals(super.settings);

  @override
  List<CustomPad> get list {
    final List<CustomPad> grid = [];

    for (int row = 0; row < settings.height; row++) {
      int next = settings.baseNote;
      for (int note = 0; note < settings.width; note++) {
        grid.add(CustomPad(
          next + row * settings.customIntervalY,
          pitchBendLeft: settings.customIntervalX,
          pitchBendRight: settings.customIntervalX,
        ));
        next = next + settings.customIntervalX;
      }
    }

    return grid;
  }
}

/// Calculate a grid using only scale notes in Key with custom in-scale Intervals on X and Y
class GridInScaleCustom extends Grid {
  GridInScaleCustom(super.settings, {this.fixedXY}) {
    fixedXY ??= Vector2Int(settings.customIntervalX, settings.customIntervalY);
    allScaleNotes = getScaleNotes(settings.scaleList, settings.rootNote);
  }

  Vector2Int? fixedXY;
  late final List<int> allScaleNotes;

  /// Produces all notes in a scale between 0 and 127 given a scale of notes between 0 and 11
  List<int> getScaleNotes(List<int> scaleNotes, int root) {
    const semitonesPerOctave = 12;
    int midiRoot = root + (root * semitonesPerOctave);
    Set<int> midiNotes = {}; // Use a Set to ensure uniqueness

    // Iterate through all possible MIDI values (0 to 127)
    for (int midiNote = 0; midiNote < 128; midiNote++) {
      // Calculate the equivalent scale note based on the MIDI value
      int note = (midiNote - midiRoot) % semitonesPerOctave;

      // Check if the note is part of the provided scale pattern
      if (scaleNotes.contains(note)) {
        midiNotes.add(midiNote);
      }
    }

    return midiNotes.toList(); // Return a list of unique MIDI values
  }

  @override
  List<CustomPad> get list {
    /// applied scale pattern to currently selected root note
    /// root note is a value between 0-11
    final List<int> actualScaleNotes =
        MidiUtils.absoluteScaleNotes(settings.rootNote, settings.scaleList);

    /// baseNote that is actually part of the currently selected scale
    int validatedBaseCheck =
        settings.baseNote; // basenote is a value between 0-127
    while (!actualScaleNotes.contains(validatedBaseCheck % 12)) {
      validatedBaseCheck = (validatedBaseCheck + 1) % 127;
    }

    /// ScaleNotes Index of first Note in the Row
    int rowStartIndex = allScaleNotes.indexOf(
        validatedBaseCheck); // init with the index in the scalelist of the first note in the grid

    /// List of all the calculated Notes in the grid
    final List<CustomPad> grid = [];

    // CALCULATE GRID:
    for (int row = 0; row < settings.height; row++) {
      // X - GET ROW
      for (int note = 0; note < settings.width; note++) {
        int nextNote = rowStartIndex + note * fixedXY!.x;

        if (nextNote >= allScaleNotes.length || nextNote.isNegative) {
          grid.add(CustomPad(999)); // an out of range pad
        } else {
          final int next = allScaleNotes[nextNote];

          // calculate left and right pitch difference:
          final int actualNextNote = next % 12;
          final int actualNextNoteIndex =
              actualScaleNotes.indexOf(actualNextNote);

          int left = Utils.getValueAfterSteps(
                  actualScaleNotes, actualNextNoteIndex, -fixedXY!.x)
              .abs();
          left = left > actualNextNote
              ? actualNextNote + 12 - left
              : actualNextNote - left;
          int right = Utils.getValueAfterSteps(
                  actualScaleNotes, actualNextNoteIndex, fixedXY!.x)
              .abs();
          right = right < actualNextNote
              ? right + 12 - actualNextNote
              : right - actualNextNote;

          // print([left, next, right]);

          grid.add(CustomPad(
            next,
            pitchBendLeft: left,
            pitchBendRight: right,
          ));
        }
      }

      // Y - GET NEXT ROW START
      rowStartIndex = (rowStartIndex + fixedXY!.y);
    }

    return grid;
  }
}

/// The Magic Tone Network grid
class GridMTN extends Grid {
  GridMTN(super.settings);

  @override
  List<CustomPad> get list {
    final List<CustomPad> grid = [];

    final bool sameColumn = settings.rootNote % 2 ==
        settings.baseNote % 2; // in the MTN, odd and even columns alternate

    for (int row = 0; row < settings.height; row++) {
      int next = settings.baseNote;
      for (int note = 0; note < settings.width; note++) {
        final bool tickTock = note.isEven ? sameColumn : !sameColumn;

        final int left = tickTock ? -5 : 7;
        final int right = tickTock ? 7 : -5;
        // print([left, next, right]);

        grid.add(CustomPad(
          next + row * 4,
          pitchBendLeft: left,
          pitchBendRight: right,
        ));

        if (note.isEven) {
          next = sameColumn ? next + 7 : next - 5;
        } else {
          next = sameColumn ? next - 5 : next + 7;
        }
      }
    }

    return grid;
  }
}

class GridXpressPads extends Grid {
  GridXpressPads(super.settings, this.xPressPads);

  final XPP xPressPads;

  @override
  List<CustomPad> get list {
    return xPressPads.list.map(CustomPad.new).toList();
  }
}
