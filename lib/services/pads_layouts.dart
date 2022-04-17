import 'package:beat_pads/screen_home/model_settings.dart';
import 'package:beat_pads/services/_services.dart';

abstract class LayoutUtils {
  /// get Layout from its name as a String
  static Layout? fromString(String key) {
    for (Layout layout in Layout.values) {
      if (layout.name == key) return layout;
    }
    return null;
  }
}

/// Selectable Pad Grid Layouts
enum Layout {
  continuous,
  scaleNotesOnly,
  minorThird,
  majorThird,
  quart,
  magicToneNetwork,
  xPressPadsStandard,
  xPressPadsLatinJazz,
}

extension LayoutExt on Layout {
  LayoutProps get props {
    switch (this) {
      case Layout.xPressPadsStandard:
        return LayoutProps(resizable: false);
      case Layout.xPressPadsLatinJazz:
        return LayoutProps(resizable: false);
      default:
        return LayoutProps(resizable: true);
    }
  }

  Grid getGrid(Settings settings) {
    switch (this) {
      case Layout.continuous:
        return GridRowInterval(settings, rowInterval: settings.width);
      case Layout.minorThird:
        return GridRowInterval(settings, rowInterval: 3);
      case Layout.majorThird:
        return GridRowInterval(settings, rowInterval: 4);
      case Layout.quart:
        return GridRowInterval(settings, rowInterval: 5);
      case Layout.scaleNotesOnly:
        return GridScaleOnly(settings);
      case Layout.xPressPadsStandard:
        return GridXpressPads(settings, XPP.standard);
      case Layout.xPressPadsLatinJazz:
        return GridXpressPads(settings, XPP.latinJazz);
      case Layout.magicToneNetwork:
        return GridMTN(settings);
    }
  }
}

class LayoutProps {
  LayoutProps({
    required this.resizable,
    this.defaultDimensions = const Vector2D(4, 4),
  });

  final bool resizable;
  final Vector2D defaultDimensions;
}

abstract class Grid {
  /// Creates a Pad Grid generating class using the current settings
  Grid(this.settings);

  final Settings settings;

  /// Get a List of all notes in the current grid
  List<int> get list;

  /// Get a List of Rows of all notes in the grid, starting from the top Row
  /// Useful for building the grid with a Column Widget
  List<List<int>> get rows {
    return List.generate(
      settings.height,
      (row) => List.generate(settings.width, (note) {
        return list[row * settings.width + note];
      }),
    ).reversed.toList();
  }
}

class GridRowInterval extends Grid {
  GridRowInterval(Settings settings, {required this.rowInterval})
      : super(settings);

  final int rowInterval;

  @override
  List<int> get list {
    List<int> grid = [];
    for (int row = 0; row < settings.height; row++) {
      for (int note = 0; note < settings.width; note++) {
        grid.add(settings.baseNote + row * rowInterval + note);
      }
    }
    return grid;
  }
}

class GridMTN extends Grid {
  GridMTN(Settings settings) : super(settings);

  @override
  List<int> get list {
    List<int> grid = [];

    bool sameColumn = settings.rootNote % 2 ==
        settings.baseNote % 2; // in the MTN, odd and even columns alternate

    for (int row = 0; row < settings.height; row++) {
      int next = settings.baseNote;
      for (int note = 0; note < settings.width; note++) {
        grid.add(next + row * 4);
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
  GridScaleOnly(Settings settings) : super(settings);

  @override
  List<int> get list {
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

    List<int> grid =
        List.generate(settings.width * settings.height, (gridIndex) {
      int out = actualNotes[(gridIndex + baseOffset) % actualNotes.length] +
          settings.baseNote ~/ 12 * 12;

      if (out < lastResult) octave++;
      lastResult = out;

      return out + 12 * octave;
    });

    return grid;
  }
}

class GridXpressPads extends Grid {
  GridXpressPads(Settings settings, this.xPressPads) : super(settings);

  final XPP xPressPads;

  @override
  List<int> get list {
    return xPressPads.list;
  }
}

// constant data about XPP layouts
enum XPP { standard, latinJazz }

extension XPPConstants on XPP {
  List<int> get list {
    switch (this) {
      case XPP.standard:
        return standard;
      case XPP.latinJazz:
        return latinJazz;
    }
  }

  static const List<int> standard = [
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
    49
  ];
  static const List<int> latinJazz = [
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
    51
  ];
}
