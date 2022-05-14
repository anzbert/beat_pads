enum MPEModulation {
  afterTouch("Aftertouch", center64: false),
  pitchBend("Pitchbend", center64: true),
  slide("Slide", center64: false),
  slide64("Slide (center 64)", center64: true),
  // cc("CC (Center 0)", false),
  // cc64("CC (Center 64)", true)
  ;

  final String title;
  final bool center64;
  const MPEModulation(
    this.title, {
    required this.center64,
  });

  static MPEModulation? fromName(String key) {
    for (MPEModulation mode in MPEModulation.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }
}

enum RadiusModulation {
  afterTouch("Aftertouch"),
  ;

  final String title;
  const RadiusModulation(this.title);

  static RadiusModulation? fromName(String key) {
    for (RadiusModulation mode in RadiusModulation.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }
}
