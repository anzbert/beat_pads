import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Uses default PlayModeHandler behaviour
class PlayModeNoSlide extends PlayModeHandler {
  @override
  build() {
    return this;
  }
}

abstract class PlayModeHandler extends Notifier {
  void handleNewTouch(PadTouchAndScreenData data) {
    if (ref.read(modReleaseUsable) > 0 || ref.read(noteReleaseUsable) > 0) {
      ref
          .read(touchReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    NoteEvent noteOn = NoteEvent(ref.read(channelUsableProv), data.padNote,
        velocityProvider.velocity(data.yPercentage))
      ..noteOn(cc: ref.read(sendCCProv));

    ref.read(touchBuffer.notifier).addNoteOn(
        CustomPointer(data.pointer, data.screenTouchPos),
        noteOn,
        data.screenSize);
  }

  void handlePan(NullableTouchAndScreenData data) {}

  void handleEndTouch(CustomPointer touch) {
    TouchEvent? eventInBuffer =
        ref.read(touchBuffer.notifier).getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (ref.read(modReleaseUsable) == 0 && ref.read(noteReleaseUsable) == 0) {
      eventInBuffer.noteEvent.noteOff();
      releaseMPEChannel(eventInBuffer.noteEvent.channel);
      ref.read(touchBuffer.notifier).remove(eventInBuffer);
    } else {
      if (ref.read(modReleaseUsable) == 0 && ref.read(noteReleaseUsable) > 0) {
        eventInBuffer.newPosition = eventInBuffer.origin; // mod to zero
      }
      ref.read(touchReleaseBuffer.notifier).updateReleasedEvent(
          eventInBuffer); // instead of note off, event passed to release buffer
      ref.read(touchBuffer.notifier).remove(eventInBuffer);
    }
  }

  void killAllNotes() {
    ref.read(touchBuffer.notifier).allNotesOff();
    ref.read(touchReleaseBuffer.notifier).allNotesOff();
  }

  void markDirty() {
    for (var event in touchBuffer.buffer) {
      event.markDirty();
    }
    for (var event in touchReleaseBuffer.buffer) {
      event.markDirty();
    }
  }

  /// Returns the velocity if a given note is ON in any channel.
  /// Checks releasebuffer and active touchbuffer
  int isNoteOn(int note) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (touch.noteEvent.note == note && touch.noteEvent.isPlaying) {
        return touch.noteEvent.velocity;
        // return true;
      }
    }
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      for (TouchEvent event in touchReleaseBuffer.buffer) {
        if (event.noteEvent.note == note && event.noteEvent.isPlaying) {
          return event.noteEvent.velocity;
          // return true;
        }
      }
    }
    return 0;
    // return false;
  }

  /// Does nothing, unless overridden in MPE
  void releaseMPEChannel(int channel) {}
}
