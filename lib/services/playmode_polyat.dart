import 'package:beat_pads/services/services.dart';

class PlayModePolyAT extends PlayModeHandler {
  final ModPolyAfterTouch1D polyATMod;
  PlayModePolyAT(super.settings, super.screenSize, super.notifyParent)
      : polyATMod = ModPolyAfterTouch1D();

  @override
  void handleNewTouch(CustomPointer touch, int noteTapped) {
    polyATMod.send(settings.channel, noteTapped, 0);
    super.handleNewTouch(touch, noteTapped);
  }

  @override
  void handlePan(CustomPointer touch, int? note) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
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
