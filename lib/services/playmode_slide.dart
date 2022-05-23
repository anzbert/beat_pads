import 'package:beat_pads/services/services.dart';

class PlayModeSlide extends PlayModeHandler {
  PlayModeSlide(
    super.settings,
    super.screenSize,
    super.notifyParent,
  );

  @override
  void handleNewTouch(CustomPointer touch, int noteTapped) {
    // TODO: implement handleNewTouch
  }

  @override
  void handlePan(CustomPointer touch, int? note) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer) ??
        releaseBuffer.getByID(touch.pointer);
    if (eventInBuffer == null || eventInBuffer.dirty) return;

    // Turn note off:
    if (note != eventInBuffer.noteEvent.note &&
        eventInBuffer.noteEvent.noteOnMessage != null) {
      if (settings.sustainTimeUsable == 0) {
        eventInBuffer.noteEvent.noteOff();
      } else {
        releaseBuffer.updateReleasedEvent(
          eventInBuffer,
        );
        eventInBuffer.noteEvent.noteOnMessage = null;
      }

      notifyParent();
    }
    // Play new note:
    if (note != null && eventInBuffer.noteEvent.noteOnMessage == null) {
      eventInBuffer
          .noteEvent = NoteEvent(settings.channel, note, settings.velocity)
        ..noteOn(cc: settings.playMode.singleChannel ? settings.sendCC : false);
      notifyParent();
    }
  }
}
