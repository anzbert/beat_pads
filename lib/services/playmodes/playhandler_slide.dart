import 'package:beat_pads/services/services.dart';

class PlayModeSlide extends PlayModeHandler {
  /// Sliding playmode. Uses notereleasebuffer instead of touchreleasebuffer,
  /// since one touch can be the cause of many released notes in this mode.
  /// There is no modulation, hence no tracking of touch required
  PlayModeSlide(super.ref);

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    if (ref.read(noteReleaseUsable) > 0) {
      ref
          .read(noteReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    final NoteEvent noteOn = NoteEvent(
      ref.read(channelUsableProv),
      data.padNote,
      ref.read(velocitySliderValueProv.notifier).velocity(data.yPercentage),
    )..noteOn(cc: ref.read(sendCCProv));

    ref.read(touchBuffer.notifier).addNoteOn(
          CustomPointer(data.pointer, data.screenTouchPos),
          noteOn,
          data.screenSize,
        );
  }

  @override
  void handlePan(NullableTouchAndScreenData data) {
    // Turn note off:
    ref.read(touchBuffer.notifier).modifyEvent(data.pointer, (eventInBuffer) {
      if (eventInBuffer.dirty) return;

      if (data.padNote != eventInBuffer.noteEvent.note &&
          eventInBuffer.noteEvent.noteOnMessage != null) {
        if (ref.read(noteReleaseUsable) == 0) {
          eventInBuffer.noteEvent.noteOff(); // turn note off immediately
        } else {
          ref.read(noteReleaseBuffer.notifier).updateReleasedNoteEvent(
                NoteEvent(
                  eventInBuffer.noteEvent.channel,
                  eventInBuffer.noteEvent.note,
                  eventInBuffer.noteEvent.noteOnMessage?.velocity ??
                      ref
                          .read(velocitySliderValueProv.notifier)
                          .velocity(data.yPercentage ?? .5),
                ),
              ); // add note event to release buffer
          eventInBuffer.noteEvent.clear();
        }

        // Play new note:
        if (data.padNote != null &&
            eventInBuffer.noteEvent.noteOnMessage == null) {
          eventInBuffer.noteEvent = NoteEvent(
            ref.read(channelUsableProv),
            data.padNote!,
            ref
                .read(velocitySliderValueProv.notifier)
                .velocity(data.yPercentage ?? .5),
          )..noteOn(
              cc: ref.read(playModeProv).singleChannel && ref.read(sendCCProv),
            );
        }
      }
    });
  }

  @override
  void handleEndTouch(CustomPointer touch) {
    ref.read(touchBuffer.notifier).modifyEvent(touch.pointer, (eventInBuffer) {
      if (ref.read(noteReleaseUsable) == 0) {
        eventInBuffer.noteEvent.noteOff(); // noteOFF
        ref.read(touchBuffer.notifier).removeById(eventInBuffer.uniqueID);
      } else {
        ref.read(noteReleaseBuffer.notifier).updateReleasedNoteEvent(
              eventInBuffer.noteEvent,
            ); // instead of note off, event passed to release buffer
        ref.read(touchBuffer.notifier).removeById(eventInBuffer.uniqueID);
      }
    });
  }

  /// Returns the velocity if a given note is ON in any channel, or,
  ///  if provided, in a specific channel.
  /// Checks releasebuffer and active touchbuffer
  @override
  int isNoteOn(int note) {
    int result = ref.read(touchBuffer.notifier).isNoteOn(note);

    if (ref.read(modReleaseUsable) > 0 || ref.read(noteReleaseUsable) > 0) {
      if (result == 0) {
        result = ref.read(noteReleaseBuffer.notifier).isNoteOn(note);
      }
    }

    return result;
  }

  @override
  void killAllNotes() {
    ref.read(touchBuffer.notifier).allNotesOff();
    ref.read(noteReleaseBuffer.notifier).allNotesOff();
  }
}
