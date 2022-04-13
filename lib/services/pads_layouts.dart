/// Selectable Pad Grid Layouts
enum Layout {
  continuous,
  scaleNotesOnly,
  minorThird,
  majorThird,
  quart,
  toneNetwork,
  xPressPadsStandard
}

abstract class LayoutUtils {
  static Layout? fromString(String key) {
    for (Layout layout in Layout.values) {
      if (layout.name == key) return layout;
    }
    return null;
  }
}

/// Returns true if a Layout is variable or false if it is a fixed Layout
extension Variable on Layout {
  bool get variable {
    switch (this) {
      case Layout.xPressPadsStandard:
        return false;
      default:
        return true;
    }
  }
}
