import 'package:beat_pads/services/services.dart';

class PlayModePolyAT extends PlayModeHandler {
  PlayModePolyAT(super.screenSize, super.notifyParent)
      : polyATMod = ModPolyAfterTouch1D();
  final ModPolyAfterTouch1D polyATMod;

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    polyATMod.send(
      0,
      settings.channel,
      data.customPad.padValue,
    );
    super.handleNewTouch(data);
  }

  @override
  void handlePan(NullableTouchAndScreenData data) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer) ??
        touchReleaseBuffer.getByID(data.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.updatePosition(data.screenTouchPos);
    notifyParent(); // for circle drawing

    polyATMod.send(
      eventInBuffer.radialChange(),
      settings.channel,
      eventInBuffer.noteEvent.note,
    );
  }

  // @override
  // void handleEndTouch(CustomPointer touch) {
  //   final TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer) ??
  //       touchReleaseBuffer.getByID(touch.pointer);

  //   if (eventInBuffer != null) {
  //     polyATMod.send(
  //       0,
  //       settings.channel,
  //       eventInBuffer.noteEvent.note,
  //     );
  //   }

  //   super.handleEndTouch(touch);
  // }
}
