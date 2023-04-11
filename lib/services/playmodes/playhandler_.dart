import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The usable sender object, which refreshes when the playmode changes
final senderProvider = Provider<PlayModeHandler>((ref) {
  final playMode = ref.watch(playModeProv);

  return playMode.getPlayModeApi(ref);
});

// Uses default PlayModeHandler behaviour
class PlayModeNoSlide extends PlayModeHandler {
  PlayModeNoSlide(super.ref);
}

abstract class PlayModeHandler {
  final ProviderRef<PlayModeHandler> ref;

  PlayModeHandler(this.ref);

  void handleNewTouch(PadTouchAndScreenData data) {
    if (ref.read(modReleaseUsable) > 0 || ref.read(noteReleaseUsable) > 0) {
      ref
          .read(touchReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    NoteEvent noteOn = NoteEvent(ref.read(channelUsableProv), data.padNote,
        ref.read(velocitySliderValueProv.notifier).velocity(data.yPercentage))
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
    ref.read(touchBuffer.notifier).markDirty();
    ref.read(touchReleaseBuffer.notifier).markDirty();
  }

  /// Returns the velocity if a given note is ON in any channel.
  /// Checks releasebuffer and active touchbuffer
  int isNoteOn(int note) {
    int result = ref.read(touchBuffer.notifier).isNoteOn(note);

    if (ref.read(modReleaseUsable) > 0 || ref.read(noteReleaseUsable) > 0) {
      if (result == 0) {
        result = ref.read(touchReleaseBuffer.notifier).isNoteOn(note);
      }
    }

    return result;
  }

  /// Does nothing, unless overridden in MPE
  void releaseMPEChannel(int channel) {}
}
