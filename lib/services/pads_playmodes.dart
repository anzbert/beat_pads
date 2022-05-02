enum PlayMode {
  slide("Slide"),
  noSlide("No Slide"),
  polyAT("Aftertouch (test)"),
  cc("Send CC (test)"),
  mpe("MPE (test)");

  const PlayMode(this.title);
  final String title;

  static PlayMode? fromName(String key) {
    for (PlayMode mode in PlayMode.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  bool get afterTouch {
    switch (this) {
      case PlayMode.polyAT:
        return true;
      case PlayMode.cc:
        return true;
      case PlayMode.mpe:
        return true;
      default:
        return false;
    }
  }
}