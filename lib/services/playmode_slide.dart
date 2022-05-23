import 'package:beat_pads/services/services.dart';

class PlayModeSlide extends PlayModeHandler {
  final NoteReleaseBuffer noteReleaseBuffer;

  PlayModeSlide(
    super.settings,
    super.screenSize,
    super.notifyParent,
  ) : noteReleaseBuffer = NoteReleaseBuffer(settings, notifyParent);

  @override
  void handleNewTouch(CustomPointer touch, int noteTapped) {
    if (settings.sustainTimeUsable > 0) {
      noteReleaseBuffer.removeNoteFromReleaseBuffer(noteTapped);
    }

    NoteEvent noteOn =
        NoteEvent(settings.channel, noteTapped, settings.velocity)
          ..noteOn(cc: settings.sendCC);

    touchBuffer.addNoteOn(touch, noteOn);
    notifyParent();
  }

  @override
  void handlePan(CustomPointer touch, int? note) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null || eventInBuffer.dirty) return;

    // Turn note off:
    if (note != eventInBuffer.noteEvent.note &&
        eventInBuffer.noteEvent.noteOnMessage != null) {
      if (settings.sustainTimeUsable == 0) {
        eventInBuffer.noteEvent.noteOff(); // turn note off immediately
      } else {
        noteReleaseBuffer.updateReleasedNoteEvent(
          NoteEvent(
            eventInBuffer.noteEvent.channel,
            eventInBuffer.noteEvent.note,
            eventInBuffer.noteEvent.noteOnMessage?.velocity ??
                settings.velocity,
          ),
        ); // add touchevent to release buffer
        eventInBuffer.noteEvent.clear();
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

  @override
  void handleEndTouch(CustomPointer touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (settings.sustainTimeUsable == 0) {
      eventInBuffer.noteEvent.noteOff(); // noteOFF
      touchBuffer.remove(eventInBuffer);
      notifyParent();
    } else {
      noteReleaseBuffer.updateReleasedNoteEvent(eventInBuffer
          .noteEvent); // instead of note off, event passed to release buffer
      touchBuffer.remove(eventInBuffer);
    }
  }

  /// Returns if a given note is ON in any channel, or, if provided, in a specific channel.
  /// Checks releasebuffer and active touchbuffer
  @override
  bool isNoteOn(int note, [int? channel]) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (channel == null && touch.noteEvent.note == note) return true;
      if (channel == channel && touch.noteEvent.note == note) return true;
    }
    if (settings.sustainTimeUsable > 0) {
      for (NoteEvent event in noteReleaseBuffer.buffer) {
        if (channel == null && event.note == note) return true;
        if (channel == channel && event.note == note) return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    for (TouchEvent touch in touchBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
    for (NoteEvent note in noteReleaseBuffer.buffer) {
      note.noteOff();
    }
  }
}
