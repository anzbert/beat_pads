import 'package:beat_pads/services/services.dart';

enum Layout {
  majorThird('Chromatic - Vertical Maj 3rd'),
  quart('Chromatic - Vertical 4th'),
  quint('Chromatic - Vertical 5th'),
  customIntervals('Chromatic - Custom X & Y', custom: true),
  continuous('Chromatic - Sequential'),
  scaleNotes3rd('In Key - Vertical 3rd'),
  scaleNotes4th('In Key - Vertical 4th'),
  scaleNotesCustom('In Key - Custom X & Y', custom: true),
  scaleNotesOnly('In Key - Sequential'),
  magicToneNetwork('Magic Tone Network™', defaultDimensions: Vector2Int(8, 8)),
  xPressPadsStandard('XpressPads™ Standard 4x4',
      resizable: false,
      defaultDimensions: Vector2Int(4, 4),
      gmPercussion: true),
  xPressPadsLatinJazz('XpressPads™ Latin/Jazz 4x4',
      resizable: false,
      defaultDimensions: Vector2Int(4, 4),
      gmPercussion: true),
  xPressPadsXO('XpressPads™ with XO 4x4',
      resizable: false, defaultDimensions: Vector2Int(4, 4)),
  xPressPadsXtreme('XpressPads™ Xtreme 8x4',
      resizable: false,
      defaultDimensions: Vector2Int(8, 4),
      gmPercussion: true);

  const Layout(
    this.title, {
    this.custom = false,
    this.resizable = true,
    this.gmPercussion = false,
    this.defaultDimensions,
  });

  final String title;
  final bool custom;
  final bool resizable;
  final bool gmPercussion;
  final Vector2Int? defaultDimensions;

  @override
  String toString() => title;

  Grid getGrid(int width, int height, int rootNote, int baseNote,
      List<int> scaleList, int customIntervalX, int customIntervalY) {
    final GridData settings = GridData(width, height, rootNote, baseNote,
        scaleList, customIntervalX, customIntervalY);

    switch (this) {
      case Layout.majorThird:
        return GridRowInterval(settings, rowInterval: 4);
      case Layout.quart:
        return GridRowInterval(settings, rowInterval: 5);
      case Layout.quint:
        return GridRowInterval(settings, rowInterval: 7);
      case Layout.customIntervals:
        return GridCustomIntervals(settings);
      case Layout.continuous:
        return GridRowInterval(settings, rowInterval: width);

      case Layout.scaleNotes3rd:
        return GridScaleCustom(settings, fixedX: 1, fixedY: 2);
      // return GridScaleOffset(settings, 2);
      case Layout.scaleNotes4th:
        return GridScaleCustom(settings, fixedX: 1, fixedY: 3);
      // return GridScaleOffset(settings, 3);
      case Layout.scaleNotesCustom:
        return GridScaleCustom(settings);
      case Layout.scaleNotesOnly:
        return GridScaleOnly(settings);

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

  /// Get a List of Rows of all notes in the grid, starting from the top Row
  /// Useful for building the grid with a Column Widget
  List<List<CustomPad>> get rows {
    if (settings.height * settings.width != list.length) return [[]];
    return List.generate(
      settings.height,
      (row) => List.generate(settings.width, (note) {
        return list[row * settings.width + note];
      }),
    ).reversed.toList();
  }
}

class GridRowInterval extends Grid {
  GridRowInterval(super.settings, {required this.rowInterval});

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
        grid.add(CustomPad(next + row * 4));
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

class GridCustomIntervals extends Grid {
  GridCustomIntervals(super.settings);

  @override
  List<CustomPad> get list {
    final List<CustomPad> grid = [];

    for (int row = 0; row < settings.height; row++) {
      int next = settings.baseNote;
      for (int note = 0; note < settings.width; note++) {
        grid.add(CustomPad(next + row * settings.customIntervalY));
        next = next + settings.customIntervalX;
      }
    }

    return grid;
  }
}

class GridScaleOnly extends Grid {
  GridScaleOnly(super.settings);

  @override
  List<CustomPad> get list {
    final List<int> actualNotes =
        MidiUtils.absoluteScaleNotes(settings.rootNote, settings.scaleList);

    int validatedBase = settings.baseNote;
    while (!actualNotes.contains(validatedBase % 12)) {
      validatedBase = (validatedBase + 1) % 127;
    }

    final int baseOffset = actualNotes.indexOf(
      validatedBase % 12,
    ); // check where grid will start within scale

    int octave = 0;
    int lastResult = 0;

    final List<CustomPad> grid =
        List.generate(settings.width * settings.height, (gridIndex) {
      final int out =
          actualNotes[(gridIndex + baseOffset) % actualNotes.length] +
              settings.baseNote ~/ 12 * 12;

      if (out < lastResult) octave++;
      lastResult = out;

      return CustomPad(out + 12 * octave);
    });

    return grid;
  }
}

class GridScaleOffset extends Grid {
  GridScaleOffset(super.settings, this.interval);

  final int interval;

  @override
  List<CustomPad> get list {
    /// applied scale pattern to currently selected root note
    /// root note is a value between 0-11
    final List<int> actualScaleNotes =
        MidiUtils.absoluteScaleNotes(settings.rootNote, settings.scaleList);

    /// baseNote that is actually part of the currently selected scale
    int validatedBase = settings.baseNote; // basenote is a value between 0-127
    while (!actualScaleNotes.contains(validatedBase % 12)) {
      validatedBase = (validatedBase + 1) % 127;
    }

    /// index in actualNotes of the starting note
    final int baseIndex = actualScaleNotes.indexOf(validatedBase % 12);

    // GRID CALCULATION ///////////////////////////
    final List<CustomPad> grid = [];

    int nextRowStart = validatedBase;
    int nextBaseIndex = baseIndex;

    for (int row = 0; row < settings.height; row++) {
      final int baseNoteOffset = nextRowStart - actualScaleNotes[nextBaseIndex];

      // CALCULATE SINGLE ROW:
      int rowPrevAdd = 0;
      int rowOctave = 0;

      for (int note = 0; note < settings.width; note++) {
        final int additiveIndex =
            (nextBaseIndex + note) % actualScaleNotes.length;

        if (actualScaleNotes[additiveIndex] < rowPrevAdd) {
          rowOctave++;
        }

        final int next =
            baseNoteOffset + actualScaleNotes[additiveIndex] + (rowOctave * 12);

        rowPrevAdd = actualScaleNotes[additiveIndex];

        grid.add(CustomPad(next));
      }

      // CALCULATE NEXT ROW START PAD:
      nextBaseIndex = (nextBaseIndex + interval) % actualScaleNotes.length;
      final int next = baseNoteOffset + actualScaleNotes[nextBaseIndex];
      nextRowStart = next < nextRowStart ? next + 12 : next;
    }
    return grid;
  }

  // ////////////////////////////////////////////////
}

/// Calculate a grid using only scale notes in Key with custom in-scale Intervals on X and Y
class GridScaleCustom extends Grid {
  GridScaleCustom(super.settings, {this.fixedX, this.fixedY}) {
    fixedX ??= settings.customIntervalX;
    fixedY ??= settings.customIntervalY;
  }

  int? fixedY;
  int? fixedX;

  @override
  List<CustomPad> get list {
    // fixedX ??= settings.customIntervalX;
    // fixedY ??= settings.customIntervalY;

    /// applied scale pattern to currently selected root note
    /// root note is a value between 0-11
    final List<int> actualScaleNotes =
        MidiUtils.absoluteScaleNotes(settings.rootNote, settings.scaleList);

    /// baseNote that is actually part of the currently selected scale
    int validatedBase = settings.baseNote; // basenote is a value between 0-127
    while (!actualScaleNotes.contains(validatedBase % 12)) {
      validatedBase = (validatedBase + 1) % 127;
    }

    /// index in actualNotes (of the scale) of the starting note
    final int baseIndex = actualScaleNotes.indexOf(validatedBase % 12);

    // MAIN GRID CALCULATION ///////////////////////////
    final List<CustomPad> grid = [];

    int nextRowStart = validatedBase;
    int nextBaseIndex = baseIndex;

    for (int row = 0; row < settings.height; row++) {
      final int baseNoteOffset = nextRowStart - actualScaleNotes[nextBaseIndex];

      // CALCULATE THE CURRENT ROW:
      for (int note = 0; note < settings.width; note++) {
        final int octavejumpsOnX = note * fixedX! ~/ actualScaleNotes.length;

        final int additiveIndex =
            (nextBaseIndex + note * fixedX!) % actualScaleNotes.length;

        final int next = baseNoteOffset +
            actualScaleNotes[additiveIndex] +
            octavejumpsOnX * 12;

        grid.add(CustomPad(next));
      }

      // CALCULATE NEXT ROW START PAD ONE STEP HIGHER ON THE Y-AXIS:
      final int octavejumpsOnY =
          (nextBaseIndex + fixedY!) ~/ actualScaleNotes.length;

      nextBaseIndex = (nextBaseIndex + fixedY!) % actualScaleNotes.length;

      nextRowStart = baseNoteOffset +
          actualScaleNotes[nextBaseIndex] +
          octavejumpsOnY * 12;
    }
    return grid;
  }

  // ////////////////////////////////////////////////
}

class GridXpressPads extends Grid {
  GridXpressPads(super.settings, this.xPressPads);

  final XPP xPressPads;

  @override
  List<CustomPad> get list {
    return xPressPads.list.map(CustomPad.new).toList();
  }
}

// constant data about XPP layouts:
enum XPP {
  standard,
  latinJazz,
  xo,
  xtreme;

  List<int> get list {
    switch (this) {
      case XPP.standard:
        return XppConstants.standardGrid;
      case XPP.latinJazz:
        return XppConstants.latinJazzGrid;
      case XPP.xo:
        return XppConstants.standardGridXO;
      case XPP.xtreme:
        return XppConstants.xtremeGrid;
    }
  }
}

abstract class XppConstants {
  static const List<int> standardGrid = [
    36,
    42,
    42,
    36,
    38,
    46,
    46,
    38,
    43,
    50,
    50,
    43,
    49,
    51,
    51,
    49,
  ];
  static const List<int> standardGridXO = [
    36,
    40,
    40,
    36,
    38,
    41,
    41,
    38,
    39,
    42,
    42,
    39,
    43,
    37,
    37,
    43,
  ];
  static const List<int> latinJazzGrid = [
    36,
    44,
    44,
    36,
    43,
    49,
    49,
    43,
    50,
    38,
    38,
    50,
    51,
    37,
    37,
    51,
  ];
  static const List<int> xtremeGrid = [
    37,
    36,
    42,
    51,
    51,
    42,
    36,
    37,
    40,
    38,
    46,
    53,
    53,
    46,
    38,
    40,
    41,
    43,
    47,
    50,
    50,
    47,
    43,
    41,
    55,
    49,
    56,
    57,
    57,
    56,
    49,
    55,
  ];
}
