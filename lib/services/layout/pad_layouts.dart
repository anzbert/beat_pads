import 'package:beat_pads/services/services.dart';

enum Layout {
  majorThird("Major Third"),
  minorThird("Minor Third"),
  quart("Quart"),
  continuous("Continuous"),
  scaleNotesOnly("Scale - Continuous"),
  scaleNotes3rd("Scale - 3rd"),
  scaleNotes4th("Scale - 4th"),
  magicToneNetwork('Magic Tone Network™'),
  xPressPadsStandard("XpressPads™ Standard 4x4"),
  xPressPadsLatinJazz("XpressPads™ Latin/Jazz 4x4"),
  xPressPadsXO("XpressPads™ with XO 4x4"),
  xPressPadsXtreme("XpressPads™ Xtreme 8x4");

  const Layout(this.title);
  final String title;

  @override
  String toString() => title;

  static Layout? fromName(String key) {
    for (Layout mode in Layout.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  bool get gmPercussion {
    switch (this) {
      case Layout.xPressPadsStandard:
        return true;
      case Layout.xPressPadsLatinJazz:
        return true;
      case Layout.xPressPadsXtreme:
        return true;
      default:
        return false;
    }
  }

  LayoutProps get props {
    switch (this) {
      case Layout.magicToneNetwork:
        return LayoutProps(
            resizable: true, defaultDimensions: const Vector2Int(8, 8));
      case Layout.xPressPadsStandard:
        return LayoutProps(
            resizable: false, defaultDimensions: const Vector2Int(4, 4));
      case Layout.xPressPadsLatinJazz:
        return LayoutProps(
            resizable: false, defaultDimensions: const Vector2Int(4, 4));
      case Layout.xPressPadsXO:
        return LayoutProps(
            resizable: false, defaultDimensions: const Vector2Int(4, 4));
      case Layout.xPressPadsXtreme:
        return LayoutProps(
            resizable: false, defaultDimensions: const Vector2Int(8, 4));
      default:
        return LayoutProps(resizable: true);
    }
  }

  Grid getGrid(
      int width, int height, int rootNote, int baseNote, List<int> scaleList) {
    GridData settings = GridData(width, height, rootNote, baseNote, scaleList);

    switch (this) {
      case Layout.continuous:
        return GridRowInterval(settings, rowInterval: width);
      case Layout.minorThird:
        return GridRowInterval(settings, rowInterval: 3);
      case Layout.majorThird:
        return GridRowInterval(settings, rowInterval: 4);
      case Layout.quart:
        return GridRowInterval(settings, rowInterval: 5);
      case Layout.scaleNotesOnly:
        // return GridScaleOffset(settings, settings.width);
        return GridScaleOnly(settings);
      case Layout.scaleNotes4th:
        return GridScaleOffset(settings, 3);
      case Layout.scaleNotes3rd:
        return GridScaleOffset(settings, 2);
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

class GridData {
  final int width;
  final int height;
  final int rootNote;
  final int baseNote;
  final List<int> scaleList;

  GridData(
      this.width, this.height, this.rootNote, this.baseNote, this.scaleList);
}

class LayoutProps {
  LayoutProps({
    required this.resizable,
    this.defaultDimensions,
  });

  final bool resizable;
  final Vector2Int? defaultDimensions;
}

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
  GridRowInterval(GridData settings, {required this.rowInterval})
      : super(settings);

  final int rowInterval;

  @override
  List<CustomPad> get list {
    List<CustomPad> grid = [];
    for (int row = 0; row < settings.height; row++) {
      for (int note = 0; note < settings.width; note++) {
        grid.add(CustomPad(settings.baseNote + row * rowInterval + note));
      }
    }
    return grid;
  }
}

class GridMTN extends Grid {
  GridMTN(GridData settings) : super(settings);

  @override
  List<CustomPad> get list {
    List<CustomPad> grid = [];

    bool sameColumn = settings.rootNote % 2 ==
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

class GridScaleOnly extends Grid {
  GridScaleOnly(GridData settings) : super(settings);

  @override
  List<CustomPad> get list {
    List<int> actualNotes =
        MidiUtils.absoluteScaleNotes(settings.rootNote, settings.scaleList);

    int validatedBase = settings.baseNote;
    while (!actualNotes.contains(validatedBase % 12)) {
      validatedBase = (validatedBase + 1) % 127;
    }

    int baseOffset = actualNotes.indexOf(
        validatedBase % 12); // check where grid will start within scale

    int octave = 0;
    int lastResult = 0;

    List<CustomPad> grid =
        List.generate(settings.width * settings.height, (gridIndex) {
      int out = actualNotes[(gridIndex + baseOffset) % actualNotes.length] +
          settings.baseNote ~/ 12 * 12;

      if (out < lastResult) octave++;
      lastResult = out;

      return CustomPad(out + 12 * octave);
    });

    return grid;
  }
}

class GridScaleOffset extends Grid {
  GridScaleOffset(GridData settings, this.interval) : super(settings);

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

    int nextRowStart = validatedBase;
    int nextBaseIndex = baseIndex;

    List<CustomPad> grid = [];
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
      nextRowStart = baseNoteOffset + actualScaleNotes[nextBaseIndex];
    }
    return grid;
  }

  // ////////////////////////////////////////////////
}

class GridXpressPads extends Grid {
  GridXpressPads(GridData settings, this.xPressPads) : super(settings);

  final XPP xPressPads;

  @override
  List<CustomPad> get list {
    return xPressPads.list.map((e) => CustomPad(e)).toList();
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
