import 'package:beat_pads/services/services.dart';

enum PlayMode {
  slide("Sliding"),
  noSlide("No Sliding"),
  polyAT("Poly Aftertouch"),
  mpe("MPE");

  const PlayMode(this.title);
  final String title;

  @override
  String toString() => title;

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

  PlayModeHandler getPlayModeApi(SendSettings settings, Function notifyParent) {
    switch (this) {
      case PlayMode.mpe:
        return PlayModeMPE(settings, notifyParent);
      case PlayMode.noSlide:
        return PlayModeNoSlide(settings, notifyParent);
      case PlayMode.slide:
        return PlayModeSlide(settings, notifyParent);
      case PlayMode.polyAT:
        return PlayModePolyAT(settings, notifyParent);
    }
  }
}
