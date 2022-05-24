import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

enum PlayMode {
  slide("Sliding"),
  noSlide("No Sliding"),
  polyAT("Poly Aftertouch"),
  mpe("MPE");

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
      default:
        return false;
    }
  }

  bool get oneDimensional {
    switch (this) {
      case PlayMode.mpe:
        return false;
      default:
        return true;
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

  PlayModeHandler getPlayModeApi(
      Settings settings, Size screenSize, Function notifyParent) {
    switch (this) {
      case PlayMode.mpe:
        return PlayModeMPE(settings, screenSize, notifyParent);
      case PlayMode.noSlide:
        return PlayModeNoSlide(settings, screenSize, notifyParent);
      case PlayMode.slide:
        return PlayModeSlide(settings, screenSize, notifyParent);
      case PlayMode.polyAT:
        return PlayModePolyAT(settings, screenSize, notifyParent);
    }
  }
}
