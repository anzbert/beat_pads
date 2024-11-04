import 'package:beat_pads/services/services.dart';

class PlayModeChannelMod extends PlayModeHandler {
  PlayModeChannelMod(super.screenSize, super.notifyParent)
      : channelATMod = ModChannelAftertouch1D();
  final ModChannelAftertouch1D channelATMod;

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    if (!touchBuffer.anyOtherEventModulating(data.pointer)) {
      channelATMod.send(
        0,
        settings.channel,
        0, // note is irrelevant
      );
    }

    super.handleNewTouch(data);
  }

  @override
  void handlePan(NullableTouchAndScreenData data) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer) ??
        touchReleaseBuffer.getByID(data.pointer);
    if (eventInBuffer == null) return;

    if (touchBuffer.anyOtherEventModulating(eventInBuffer.uniqueID)) return;

    eventInBuffer.updatePosition(data.screenTouchPos);
    notifyParent(); // for circle drawing

    channelATMod.send(
      eventInBuffer.radialChange(),
      settings.channel,
      0, // note is irrelevant
    );
  }

  // @override
  // void handleEndTouch(CustomPointer touch) {
  //   if (!touchBuffer.anyOtherEventModulating(touch.pointer)) {
  //     channelATMod.send(
  //       0.0,
  //       settings.channel,
  //       0, // note is irrelevant
  //     );
  //   }
  //   super.handleEndTouch(touch);
  // }
}
