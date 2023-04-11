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
    if (ref.read(touchBuffer.notifier).eventInBuffer(data.pointer)) {
      ref.read(touchBuffer.notifier).modifyEvent(data.pointer, (eventInBuffer) {
        eventInBuffer.updatePosition(data.screenTouchPos);
        polyATMod.send(
          ref.read(channelUsableProv),
          eventInBuffer.noteEvent.note,
          eventInBuffer.radialChange(),
        );
      });
    } else if (ref
        .read(touchReleaseBuffer.notifier)
        .eventInBuffer(data.pointer)) {
      ref.read(touchReleaseBuffer.notifier).modifyEvent(data.pointer,
          (eventInBuffer) {
        eventInBuffer.updatePosition(data.screenTouchPos);
        polyATMod.send(
          ref.read(channelUsableProv),
          eventInBuffer.noteEvent.note,
          eventInBuffer.radialChange(),
        );
      });
    }
  }
}
