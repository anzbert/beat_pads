import 'package:beat_pads/services/services.dart';

// TODO Add targeted Pitch slide MPE mode like on the Push 3

enum PlayMode {
  noSlide('Disabled'),
  slide('Trigger Notes'),

  polyAT(
    'Poly Aftertouch',
    modulatable: true,
  ),

  mpe(
    'MPE',
    modulatable: true,
    oneDimensional: true,
    singleChannel: false,
  ),

  mpeTargetPb(
    'MPE - Pitch to Pad',
    modulatable: true,
    oneDimensional: true,
    singleChannel: false,
  );

  const PlayMode(
    this.title, {
    this.modulatable = false,
    this.oneDimensional = true,
    this.singleChannel = true,
  });

  final String title;

  /// Layout uses a modulation overlay and can be modulated by finger panning
  final bool modulatable;

  /// Layout uses a modulation overlay that is circular with only
  /// one modulated parameter
  final bool oneDimensional;

  /// Layout sends Midi on one channel only (Usually all Non-MPE Layouts)
  final bool singleChannel;

  @override
  String toString() => title;

  PlayModeHandler getPlayModeApi(
    SendSettings settings,
    void Function() notifyParent,
  ) {
    switch (this) {
      case PlayMode.mpe:
        return PlayModeMPE(settings, notifyParent);
      case PlayMode.mpeTargetPb:
        return PlayModeMPETargetPb(settings, notifyParent);
      case PlayMode.noSlide:
        return PlayModeNoSlide(settings, notifyParent);
      case PlayMode.slide:
        return PlayModeSlide(settings, notifyParent);
      case PlayMode.polyAT:
        return PlayModePolyAT(settings, notifyParent);
    }
  }
}
