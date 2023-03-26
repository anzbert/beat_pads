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
  void handlePan(NullableTouchAndScreenData data) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer) ??
        touchReleaseBuffer.getByID(data.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.updatePosition(data.screenTouchPos);
    notifyParent(); // for circle drawing

    polyATMod.send(
      settings.channel,
      eventInBuffer.noteEvent.note,
      eventInBuffer.radialChange(),
    );
  }
}
