import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

abstract class PlayModeHandler {
  final Settings settings;
  final Function notifyParent;

  final TouchBuffer touchBuffer;
  final ReleaseBuffer releaseBuffer;

  PlayModeHandler(
    this.settings,
    Size screenSize,
    this.notifyParent,
  )   : touchBuffer = TouchBuffer(settings, screenSize),
        releaseBuffer = ReleaseBuffer(
          settings,
          MemberChannelProvider(settings.upperZone, settings.mpeMemberChannels),
          notifyParent,
        );

  void handleNewTouch(CustomPointer touch, int noteTapped) {
    if (settings.sustainTimeUsable > 0) {
      releaseBuffer.removeNoteFromReleaseBuffer(noteTapped);
    }

    NoteEvent noteOn =
        NoteEvent(settings.channel, noteTapped, settings.velocity)
          ..noteOn(cc: settings.sendCC);

    touchBuffer.addNoteOn(touch, noteOn);
    notifyParent();
  }

  void handlePan(CustomPointer touch, int? note) {}

  void handleEndTouch(CustomPointer touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (settings.sustainTimeUsable == 0) {
      eventInBuffer.noteEvent.noteOff(); // noteOFF
      touchBuffer.remove(eventInBuffer);
      notifyParent();
    } else {
      releaseBuffer.updateReleasedEvent(
          eventInBuffer); // instead of note off, event passed to release buffer
      touchBuffer.remove(eventInBuffer);
    }
  }

  void dispose() {
    for (TouchEvent touch in touchBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
    for (TouchEvent touch in releaseBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
  }

  void markDirty() {
    for (var event in touchBuffer.buffer) {
      event.markDirty();
    }
  }

  /// Returns if a given note is ON in any channel, or, if provided, in a specific channel.
  /// Checks releasebuffer and active touchbuffer
  bool isNoteOn(int note, [int? channel]) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (channel == null && touch.noteEvent.note == note) return true;
      if (channel == channel && touch.noteEvent.note == note) return true;
    }
    if (settings.sustainTimeUsable > 0) {
      for (TouchEvent event in releaseBuffer.buffer) {
        if (channel == null && event.noteEvent.note == note) return true;
        if (channel == channel && event.noteEvent.note == note) return true;
      }
    }
    return false;
  }
}

class PlayModeNoSlide extends PlayModeHandler {
  PlayModeNoSlide(super.settings, super.screenSize, super.notifyParent);
  // Uses default PlayModeHandler behaviour
}
