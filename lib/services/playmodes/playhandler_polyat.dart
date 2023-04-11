import 'package:beat_pads/services/services.dart';

class PlayModePolyAT extends PlayModeHandler {
  final ModPolyAfterTouch1D polyATMod;
  PlayModePolyAT(super.ref) : polyATMod = ModPolyAfterTouch1D();

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    polyATMod.send(ref.read(channelUsableProv), data.padNote, 0);
    super.handleNewTouch(data);
  }

  @override
  void handlePan(NullableTouchAndScreenData data) {
    TouchEvent? eventInBuffer =
        ref.read(touchBuffer.notifier).getByID(data.pointer) ??
            ref.read(touchReleaseBuffer.notifier).getByID(data.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.updatePosition(data.screenTouchPos);

    polyATMod.send(
      ref.read(channelUsableProv),
      eventInBuffer.noteEvent.note,
      eventInBuffer.radialChange(),
    );
  }
}
