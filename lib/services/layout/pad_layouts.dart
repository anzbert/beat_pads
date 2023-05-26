import 'package:beat_pads/services/services.dart';

enum Layout {
  // minorThird('Chromatic - Min 3rd'),
  majorThird('Chromatic - Maj 3rd'),
  quart('Chromatic - 4th'),
  tritone('Chromatic - Tritone'),
  quint('Chromatic - 5th'),
  continuous('Chromatic - Sequential'),
  scaleNotes3rd('In Key - 3rd'),
  scaleNotes4th('In Key - 4th'),
  scaleNotesOnly('In Key - Sequential'),
  magicToneNetwork('Magic Tone Network™'),
  xPressPadsStandard('XpressPads™ Standard 4x4'),
  xPressPadsLatinJazz('XpressPads™ Latin/Jazz 4x4'),
  xPressPadsXO('XpressPads™ with XO 4x4'),
  xPressPadsXtreme('XpressPads™ Xtreme 8x4');

  const Layout(this.title);
  final String title;

  @override
  String toString() => title;

  bool get gmPercussion {
    switch (this) {
      case Layout.xPressPadsStandard:
        return true;
      case Layout.xPressPadsLatinJazz:
        return true;
      case Layout.xPressPadsXtreme:
        return true;
      // ignore: no_default_cases
      default:
        return false;
    }
  }

  LayoutProps get props {
    switch (this) {
      case Layout.magicToneNetwork:
        return LayoutProps(
          resizable: true,
          defaultDimensions: const Vector2Int(8, 8),
        );
      case Layout.xPressPadsStandard:
        return LayoutProps(
          resizable: false,
          defaultDimensions: const Vector2Int(4, 4),
        );
      case Layout.xPressPadsLatinJazz:
        return LayoutProps(
          resizable: false,
          defaultDimensions: const Vector2Int(4, 4),
        );
      case Layout.xPressPadsXO:
        return LayoutProps(
          resizable: false,
          defaultDimensions: const Vector2Int(4, 4),
        );
      case Layout.xPressPadsXtreme:
        return LayoutProps(
          resizable: false,
          defaultDimensions: const Vector2Int(8, 4),
        );
      // ignore: no_default_cases
      default:
        return LayoutProps(resizable: true);
    }
  }

  Grid getGrid(
    int width,
    int height,
    int rootNote,
    int baseNote,
    List<int> scaleList,
  ) {
    final settings = GridData(width, height, rootNote, baseNote, scaleList);

    switch (this) {
      // case Layout.minorThird:
      //   return GridRowInterval(settings, rowInterval: 3);
      case Layout.majorThird:
        return GridRowInterval(settings, rowInterval: 4);
      case Layout.quart:
        return GridRowInterval(settings, rowInterval: 5);
      case Layout.tritone:
        return GridRowInterval(settings, rowInterval: 6);
      case Layout.quint:
        return GridRowInterval(settings, rowInterval: 7);
      case Layout.continuous:
        return GridRowInterval(settings, rowInterval: width);
      case Layout.scaleNotes3rd:
        return GridScaleOffset(settings, 2);
      case Layout.scaleNotes4th:
        return GridScaleOffset(settings, 3);
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

class GridData {
  GridData(
    this.width,
    this.height,
    this.rootNote,
    this.baseNote,
    this.scaleList,
  );
  final int width;
  final int height;
  final int rootNote;
  final int baseNote;
  final List<int> scaleList;
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
      (row) => List.generate(
        settings.width,
        (note) => list[row * settings.width + note],
      ),
    ).reversed.toList();
  }
}

class GridRowInterval extends Grid {
  GridRowInterval(super.settings, {required this.rowInterval});

  final int rowInterval;

  @override
  List<CustomPad> get list {
    final grid = <CustomPad>[];
    for (var row = 0; row < settings.height; row++) {
      for (var note = 0; note < settings.width; note++) {
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
    final grid = <CustomPad>[];

    final sameColumn = settings.rootNote % 2 ==
        settings.baseNote % 2; // in the MTN, odd and even columns alternate

    for (var row = 0; row < settings.height; row++) {
      var next = settings.baseNote;
      for (var note = 0; note < settings.width; note++) {
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
  GridScaleOnly(super.settings);

  @override
  List<CustomPad> get list {
    final actualNotes =
        MidiUtils.absoluteScaleNotes(settings.rootNote, settings.scaleList);

    var validatedBase = settings.baseNote;
    while (!actualNotes.contains(validatedBase % 12)) {
      validatedBase = (validatedBase + 1) % 127;
    }

    final baseOffset = actualNotes.indexOf(
      validatedBase % 12,
    ); // check where grid will start within scale

    var octave = 0;
    var lastResult = 0;

    final grid =
        List<CustomPad>.generate(settings.width * settings.height, (gridIndex) {
      final out = actualNotes[(gridIndex + baseOffset) % actualNotes.length] +
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
    final actualScaleNotes =
        MidiUtils.absoluteScaleNotes(settings.rootNote, settings.scaleList);

    /// baseNote that is actually part of the currently selected scale
    var validatedBase = settings.baseNote; // basenote is a value between 0-127
    while (!actualScaleNotes.contains(validatedBase % 12)) {
      validatedBase = (validatedBase + 1) % 127;
    }

    /// index in actualNotes of the starting note
    final baseIndex = actualScaleNotes.indexOf(validatedBase % 12);

    // GRID CALCULATION ///////////////////////////
    final grid = <CustomPad>[];

    var nextRowStart = validatedBase;
    var nextBaseIndex = baseIndex;

    for (var row = 0; row < settings.height; row++) {
      final baseNoteOffset = nextRowStart - actualScaleNotes[nextBaseIndex];

      // CALCULATE SINGLE ROW:
      var rowPrevAdd = 0;
      var rowOctave = 0;

      for (var note = 0; note < settings.width; note++) {
        final additiveIndex = (nextBaseIndex + note) % actualScaleNotes.length;

        if (actualScaleNotes[additiveIndex] < rowPrevAdd) {
          rowOctave++;
        }

        final next =
            baseNoteOffset + actualScaleNotes[additiveIndex] + (rowOctave * 12);

        rowPrevAdd = actualScaleNotes[additiveIndex];

        grid.add(CustomPad(next));
      }

      // CALCULATE NEXT ROW START PAD:
      nextBaseIndex = (nextBaseIndex + interval) % actualScaleNotes.length;
      final next = baseNoteOffset + actualScaleNotes[nextBaseIndex];
      nextRowStart = next < nextRowStart ? next + 12 : next;
    }
    return grid;
  }

  // ////////////////////////////////////////////////
}

class GridXpressPads extends Grid {
  GridXpressPads(super.settings, this.xPressPads);

  final XPP xPressPads;

  @override
  List<CustomPad> get list => xPressPads.list.map(CustomPad.new).toList();
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
