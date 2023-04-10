import 'package:beat_pads/services/services.dart';

enum PlayMode {
  slide("Trigger Notes"),
  noSlide("Disabled"),
  polyAT("Poly Aftertouch"),
  mpe("MPE");

  const PlayMode(this.title);
  final String title;

  @override
  String toString() => title;

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

  PlayModeHandler getPlayModeApi(SendSettings settings) {
    switch (this) {
      case PlayMode.mpe:
        return PlayModeMPE(settings);
      case PlayMode.noSlide:
        return PlayModeNoSlide(settings);
      case PlayMode.slide:
        return PlayModeSlide(settings);
      case PlayMode.polyAT:
        return PlayModePolyAT(settings);
    }
  }
}
