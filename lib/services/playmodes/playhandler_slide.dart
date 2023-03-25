import 'package:beat_pads/services/services.dart';

class PlayModeSlide extends PlayModeHandler {
  final NoteReleaseBuffer noteReleaseBuffer;

  /// Sliding playmode. Uses notereleasebuffer instead of touchreleasebuffer,
  /// since one touch can be the cause of many released notes in this mode.
  /// There is no modulation, hence no tracking of touch required
  PlayModeSlide(
    super.settings,
    super.notifyParent,
  ) : noteReleaseBuffer = NoteReleaseBuffer(settings, notifyParent);

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    if (settings.noteReleaseTime > 0) {
      noteReleaseBuffer.removeNoteFromReleaseBuffer(data.padNote);
    }

    double percentage = 0.5;

    NoteEvent noteOn = NoteEvent(
        settings.channel, data.padNote, velocityProvider.velocity(percentage))
      ..noteOn(cc: settings.sendCC);

    touchBuffer.addNoteOn(CustomPointer(data.pointer, data.screenTouchPos),
        noteOn, data.screenSize);
    notifyParent();
  }

  @override
  void handlePan(NullableTouchAndScreenData data) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer);
    if (eventInBuffer == null || eventInBuffer.dirty) return;

    // Turn note off:
    if (data.padNote != eventInBuffer.noteEvent.note &&
        eventInBuffer.noteEvent.noteOnMessage != null) {
      if (settings.noteReleaseTime == 0) {
        eventInBuffer.noteEvent.noteOff(); // turn note off immediately
      } else {
        noteReleaseBuffer.updateReleasedNoteEvent(
          NoteEvent(
            eventInBuffer.noteEvent.channel,
            eventInBuffer.noteEvent.note,
            eventInBuffer.noteEvent.noteOnMessage?.velocity ??
                velocityProvider.velocity(data.yPercentage ?? 100),
          ),
        ); // add note event to release buffer
        eventInBuffer.noteEvent.clear();
      }

      notifyParent();
    }
    // Play new note:
    if (data.padNote != null && eventInBuffer.noteEvent.noteOnMessage == null) {
      eventInBuffer.noteEvent = NoteEvent(settings.channel, data.padNote!,
          velocityProvider.velocity(data.yPercentage ?? 100))
        ..noteOn(cc: settings.playMode.singleChannel ? settings.sendCC : false);
      notifyParent();
    }
  }

  @override
  void handleEndTouch(CustomPointer touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (settings.noteReleaseTime == 0) {
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
    if (settings.noteReleaseTime > 0) {
      for (NoteEvent event in noteReleaseBuffer.buffer) {
        if (channel == null && event.note == note) return true;
        if (channel == channel && event.note == note) return true;
      }
    }
    return false;
  }

  @override
  void killAllNotes() {
    for (TouchEvent touch in touchBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
    for (NoteEvent note in noteReleaseBuffer.buffer) {
      note.noteOff();
    }
  }
}
