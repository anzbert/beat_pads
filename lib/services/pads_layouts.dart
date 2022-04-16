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

abstract class LayoutUtils {
  static Layout? fromString(String key) {
    for (Layout layout in Layout.values) {
      if (layout.name == key) return layout;
    }
    return null;
  }
}

extension Variable on Layout {
  /// Returns true if a Layout is variable or false if it is a fixed Layout
  bool get variable {
    switch (this) {
      case Layout.xPressPadsStandard:
        return false;
      case Layout.xPressPadsLatinJazz:
        return false;
      default:
        return true;
    }
  }

  // TODO: primitive obsession??? maybe create class object for layout parameters
  List<int>? get size {
    switch (this) {
      case Layout.xPressPadsStandard:
        return [4, 4];
      case Layout.xPressPadsLatinJazz:
        return [4, 4];
      default:
        return null;
    }
  }
}
