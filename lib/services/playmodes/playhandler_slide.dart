import 'package:beat_pads/services/services.dart';

class PlayModeSlide extends PlayModeHandler {
  /// Sliding playmode. Uses notereleasebuffer instead of touchreleasebuffer,
  /// since one touch can be the cause of many released notes in this mode.
  /// There is no modulation, hence no tracking of touch required
  PlayModeSlide(
    super.settings,
    super.notifyParent,
  ) : noteReleaseBuffer = NoteReleaseBuffer(settings, notifyParent);
  final NoteReleaseBuffer noteReleaseBuffer;

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    if (settings.noteReleaseTime > 0) {
      noteReleaseBuffer.removeNoteFromReleaseBuffer(data.customPad.padValue);
    }

    final NoteEvent noteOn = NoteEvent(
      settings.channel,
      data.customPad,
      velocityProvider.velocity(data.yPercentage),
    )..noteOn(cc: settings.sendCC);

    touchBuffer.addNoteOn(
      CustomPointer(data.pointer, data.screenTouchPos),
      noteOn,
      data.screenSize,
      data.padBox,
      data.xPercentage,
      data.yPercentage,
    );
    notifyParent();
  }

  @override
  void handlePan(NullableTouchAndScreenData data) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer);
    if (eventInBuffer == null || eventInBuffer.dirty) return;

    // Turn note off:
    if (data.customPad?.padValue != eventInBuffer.noteEvent.note &&
        eventInBuffer.noteEvent.noteOnMessage != null) {
      if (settings.noteReleaseTime == 0) {
        eventInBuffer.noteEvent.noteOff(); // turn note off immediately
      } else {
        noteReleaseBuffer.updateReleasedNoteEvent(
          NoteEvent(
            eventInBuffer.noteEvent.channel,
            eventInBuffer.noteEvent.pad,
            eventInBuffer.noteEvent.noteOnMessage?.velocity ??
                velocityProvider.velocity(data.yPercentage ?? .5),
          ),
        ); // add note event to release buffer
        eventInBuffer.noteEvent.clear();
      }

      notifyParent();
    }
    // Play new note:
    if (data.customPad?.padValue != null &&
        eventInBuffer.noteEvent.noteOnMessage == null) {
      eventInBuffer.noteEvent = NoteEvent(
        settings.channel,
        data.customPad!,
        velocityProvider.velocity(data.yPercentage ?? .5),
      )..noteOn(cc: settings.playMode.singleChannel && settings.sendCC);

      notifyParent();
    }
  }

  @override
  void handleEndTouch(CustomPointer touch) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (settings.noteReleaseTime == 0) {
      eventInBuffer.noteEvent.noteOff(); // noteOFF
      touchBuffer.remove(eventInBuffer);
      notifyParent();
    } else {
      noteReleaseBuffer.updateReleasedNoteEvent(
        eventInBuffer.noteEvent,
      ); // instead of note off, event passed to release buffer
      touchBuffer.remove(eventInBuffer);
    }
  }

  /// Returns the velocity if a given note is ON in any channel, or, if provided, in a specific channel.
  /// Checks releasebuffer and active touchbuffer
  @override
  int isNoteOn(int note, [int? channel]) {
    for (final TouchEvent touch in touchBuffer.buffer) {
      if (channel == null && touch.noteEvent.note == note) {
        return touch.noteEvent.velocity;
      }
      if (channel == channel && touch.noteEvent.note == note) {
        return touch.noteEvent.velocity;
      }
    }
    if (settings.noteReleaseTime > 0) {
      for (final NoteEvent event in noteReleaseBuffer.buffer) {
        if (channel == null && event.note == note) return event.velocity;
        if (channel == channel && event.note == note) return event.velocity;
      }
    }
    return 0;
    // return false;
  }

  @override
  void killAllNotes() {
    for (final TouchEvent touch in touchBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
    for (final NoteEvent note in noteReleaseBuffer.buffer) {
      note.noteOff();
    }
  }
}
