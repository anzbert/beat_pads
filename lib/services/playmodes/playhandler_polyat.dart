import 'package:beat_pads/services/services.dart';

class PlayModePolyAT extends PlayModeHandler {
  final ModPolyAfterTouch1D polyATMod;
  PlayModePolyAT(super.screenSize, super.notifyParent)
      : polyATMod = ModPolyAfterTouch1D();

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    polyATMod.send(settings.channel, data.padNote, 0);
    super.handleNewTouch(data);
  }

  @override
  void handlePan(CustomPointer touch, int? note) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer) ??
        touchReleaseBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.updatePosition(touch.position);
    notifyParent(); // for circle drawing

    polyATMod.send(
      settings.channel,
      eventInBuffer.noteEvent.note,
      eventInBuffer.radialChange(),
    );
  }
}
