enum PlayMode {
  slide("Slide"),
  noSlide("No Slide"),
  polyAT("Aftertouch"),
  cc("Send CC");

  const PlayMode(this.title);
  final String title;

  static PlayMode? fromName(String key) {
    for (PlayMode mode in PlayMode.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }
}
