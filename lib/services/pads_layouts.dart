enum Layout {
  continuous,
  scaleNotesOnly,
  minorThird,
  majorThird,
  quart,
  toneNetwork,
  xPressPadsStandard
}

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
