enum PlayMode {
  slide("Sliding"),
  noSlide("No Sliding"),
  polyAT("Poly Aftertouch"),
  mpe("MPE"),
  // cc("Send CC"),
  ;

  const PlayMode(this.title);
  final String title;

  static PlayMode? fromName(String key) {
    for (PlayMode mode in PlayMode.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  bool get modulatable {
    switch (this) {
      case PlayMode.polyAT:
        return true;
      case PlayMode.mpe:
        return true;
      // case PlayMode.cc:
      //   return true;
      default:
        return false;
    }
  }

  bool get singleChannel {
    if (this == PlayMode.mpe) return false;
    return true;
  }

  bool get multiChannel {
    if (this == PlayMode.mpe) return true;
    return false;
  }
}
