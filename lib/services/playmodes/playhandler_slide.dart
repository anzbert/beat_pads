import 'package:beat_pads/services/services.dart';

class PlayModeSlide extends PlayModeHandler {
  /// Sliding playmode. Uses notereleasebuffer instead of touchreleasebuffer,
  /// since one touch can be the cause of many released notes in this mode.
  /// There is no modulation, hence no tracking of touch required
  PlayModeSlide(super.ref);

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    if (refRead(noteReleaseUsable) > 0) {
      refRead(noteReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    final noteOn = NoteEvent(
      refRead(channelUsableProv),
      data.padNote,
      refRead(velocitySliderValueProv.notifier)
          .generateVelocity(data.yPercentage),
    )..noteOn(cc: refRead(sendCCProv));

    refRead(touchBuffer.notifier).addNoteOn(
      CustomPointer(data.pointer, data.screenTouchPos),
      noteOn,
      data.screenSize,
    );
  }

  @override
  void handlePan(NullableTouchAndScreenData data) {
    // Turn note off:
    refRead(touchBuffer.notifier).modifyEvent(data.pointer,
        (eventInBuffer) async {
      if (eventInBuffer.dirty) return;

      if (data.padNote != eventInBuffer.noteEvent.note &&
          eventInBuffer.noteEvent.noteOnMessage != null) {
        if (refRead(noteReleaseUsable) == 0) {
          eventInBuffer.noteEvent.noteOff(); // turn note off immediately
        } else {
          await refRead(noteReleaseBuffer.notifier).updateReleasedNoteEvent(
            NoteEvent(
              eventInBuffer.noteEvent.channel,
              eventInBuffer.noteEvent.note,
              eventInBuffer.noteEvent.noteOnMessage?.velocity ??
                  refRead(velocitySliderValueProv.notifier)
                      .generateVelocity(data.yPercentage ?? .5),
            ),
          ); // add note event to release buffer
          eventInBuffer.noteEvent.clear();
        }

        // Play new note:
        if (data.padNote != null &&
            eventInBuffer.noteEvent.noteOnMessage == null) {
          eventInBuffer.noteEvent = NoteEvent(
            refRead(channelUsableProv),
            data.padNote!,
            refRead(velocitySliderValueProv.notifier)
                .generateVelocity(data.yPercentage ?? .5),
          )..noteOn(
              cc: refRead(playModeProv).singleChannel && refRead(sendCCProv),
            );
        }
      }
    });
  }

  @override
  void handleEndTouch(CustomPointer touch) {
    refRead(touchBuffer.notifier).modifyEvent(touch.pointer,
        (eventInBuffer) async {
      if (refRead(noteReleaseUsable) == 0) {
        eventInBuffer.noteEvent.noteOff(); // noteOFF
        refRead(touchBuffer.notifier).removeById(eventInBuffer.uniqueID);
      } else {
        await refRead(noteReleaseBuffer.notifier).updateReleasedNoteEvent(
          eventInBuffer.noteEvent,
        ); // instead of note off, event passed to release buffer
        refRead(touchBuffer.notifier).removeById(eventInBuffer.uniqueID);
      }
    });
  }

  /// Returns the velocity if a given note is ON in any channel, or,
  ///  if provided, in a specific channel.
  /// Checks releasebuffer and active touchbuffer
  @override
  int isNoteOn(int note) {
    var result = refRead(touchBuffer.notifier).isNoteOn(note);

    if (refRead(modReleaseUsable) > 0 || refRead(noteReleaseUsable) > 0) {
      if (result == 0) {
        result = refRead(noteReleaseBuffer.notifier).isNoteOn(note);
      }
    }

    return result;
  }

  @override
  void killAllNotes() {
    refRead(touchBuffer.notifier).allNotesOff();
    refRead(noteReleaseBuffer.notifier).allNotesOff();
  }
}
