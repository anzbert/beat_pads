import 'package:beat_pads/services/services.dart';
// import 'package:flutter/material.dart';

class PlayModeNoSlide extends PlayModeApi {
  PlayModeNoSlide(super.settings, super.screenSize, super.notifyParent);

  @override
  handleNewTouch(CustomPointer touch, int noteTapped) {
    NoteEvent noteOn =
        NoteEvent(settings.channel, noteTapped, settings.velocity)
          ..noteOn(cc: settings.sendCC);

    // remove from releasedNote buffer, if note was still pending there
    if (settings.sustainTimeUsable > 0) {
      releaseBuffer.removeNoteFromReleaseBuffer(noteTapped);
    }

    touchBuffer.addNoteOn(touch, noteOn);
    notifyParent();
  }

  @override
  void handlePan(CustomPointer touch, int? note) {}

  @override
  handleEndTouch(CustomPointer touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (settings.sustainTimeUsable == 0) {
      eventInBuffer.noteEvent.noteOff();
      touchBuffer.remove(eventInBuffer); // events gets removed

    } else {
      releaseBuffer
          .updateReleasedEvent(eventInBuffer); // event passed to release buffer
      touchBuffer.remove(eventInBuffer);
    }

    notifyParent();
  }

  @override
  void dispose() {
    for (TouchEvent touch in touchBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
    for (TouchEvent touch in releaseBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
  }
}
