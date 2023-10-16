import 'package:beat_pads/services/services.dart';

enum PlayMode {
  slide('Trigger Notes'),
  noSlide('Disabled'),
  polyAT('Poly Aftertouch'),
  mpe('MPE');

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
      // ignore: no_default_cases
      default:
        return false;
    }
  }

  bool get oneDimensional {
    switch (this) {
      case PlayMode.mpe:
        return false;
      // ignore: no_default_cases
      default:
        return true;
    }
  }

  bool get singleChannel {
    if (this == PlayMode.mpe) return false;
    return true;
  }

  PlayModeHandler getPlayModeApi(
    SendSettings settings,
    void Function() notifyParent,
  ) {
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
