import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The usable sender object, which refreshes when the playmode changes
final senderProvider = Provider<PlayModeHandler>((ref) {
  final playMode = ref.watch(playModeProv);

  return playMode.getPlayModeApi(ref);
});

/// Handler which uses the default [PlayModeHandler] behaviour
class PlayModeNoPan extends PlayModeHandler {
  /// A basic Playmode handler, which does not react to finger panning events.
  PlayModeNoPan(super.ref);
}

abstract class PlayModeHandler {
  PlayModeHandler(ProviderRef<PlayModeHandler> ref) : refRead = ref.read;

  /// Use this to to read the current settings in the [PlayModeHandler].
  /// This Function has been created to prevent from accidently using
  /// ```watch``` or ```listen``` in these Handlers.
  final T Function<T>(ProviderListenable<T>) refRead;

  void handleNewTouch(PadTouchAndScreenData data) {
    if (refRead(modReleaseUsable) > 0 || refRead(noteReleaseUsable) > 0) {
      refRead(touchReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    final noteOn = NoteEvent(
      refRead(channelUsableProv),
      data.padNote,
      refRead(velocitySliderValueProv.notifier).velocity(data.yPercentage),
    )..noteOn(cc: refRead(sendCCProv));

    refRead(touchBuffer.notifier).addNoteOn(
      CustomPointer(data.pointer, data.screenTouchPos),
      noteOn,
      data.screenSize,
    );
  }

  void handlePan(NullableTouchAndScreenData data) {}

  void handleEndTouch(CustomPointer touch) {
    if (!refRead(touchBuffer.notifier).eventInBuffer(touch.pointer)) return;

    if (refRead(modReleaseUsable) == 0 && refRead(noteReleaseUsable) == 0) {
      refRead(touchBuffer.notifier).modifyEvent(touch.pointer, (event) {
        event.noteEvent.noteOff();
      });

      refRead(touchBuffer.notifier).removeById(touch.pointer);
    } else {
      if (refRead(modReleaseUsable) == 0 && refRead(noteReleaseUsable) > 0) {
        refRead(touchBuffer.notifier).modifyEvent(touch.pointer,
            (eventInBuffer) async {
          eventInBuffer.newPosition = eventInBuffer.origin; // mod to zero
          await refRead(touchReleaseBuffer.notifier).updateReleasedEvent(
            eventInBuffer,
          ); // instead of note off, event passed to release buffer
        });
      }
      refRead(touchBuffer.notifier).removeById(touch.pointer);
    }
  }

  void killAllNotes() {
    refRead(touchBuffer.notifier).allNotesOff();
    refRead(touchReleaseBuffer.notifier).allNotesOff();
  }

  /// Prevent further input to all currently touched notes
  void markDirty() {
    refRead(touchBuffer.notifier).markDirty();
    refRead(touchReleaseBuffer.notifier).markDirty();
  }

  /// Returns the velocity if a given note is ON in any channel.
  /// Checks releasebuffer and active touchbuffer
  int isNoteOn(int note) {
    var result = refRead(touchBuffer.notifier).isNoteOn(note);

    if (refRead(modReleaseUsable) > 0 || refRead(noteReleaseUsable) > 0) {
      if (result == 0) {
        result = refRead(touchReleaseBuffer.notifier).isNoteOn(note);
      }
    }

    return result;
  }
}
