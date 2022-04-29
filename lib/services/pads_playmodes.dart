enum PlayMode {
  slide("Slide"),
  noSlide("No_Slide"),
  polyAftertouch("Poly_Aftertouch");

  const PlayMode(this.title);
  final String title;

  static PlayMode? fromName(String key) {
    for (PlayMode mode in PlayMode.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  static PlayMode? fromTitle(String key) {
    for (PlayMode mode in PlayMode.values) {
      if (mode.title == key) return mode;
    }
    return null;
  }
}
