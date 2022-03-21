enum Layout {
  continuous,
  minorThird,
  majorThird,
  quart,
  toneNetwork,
  xPressPads
}

extension Variable on Layout {
  bool get variable {
    switch (this) {
      case Layout.xPressPads:
        return false;
      default:
        return true;
    }
  }
}
