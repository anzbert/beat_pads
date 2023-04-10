import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayModeNoSlide extends PlayModeHandler {
  // PlayModeNoSlide(super.settings);

  @override
  build() {
    // TODO: implement build
    throw UnimplementedError();
  }
  // Uses default PlayModeHandler behaviour
}

abstract class PlayModeHandler extends Notifier {
  // PlayModeHandler(
  //   this.settings,
  // )   : touchBuffer = TouchBuffer(),
  //       velocityProvider = VelocityProvider(settings) {
  //   touchReleaseBuffer = TouchReleaseBuffer(
  //     releaseMPEChannel,
  //   );
  // }

  void handleNewTouch(PadTouchAndScreenData data) {
    if (ref.read(modReleaseUsable) > 0 || ref.read(noteReleaseUsable) > 0) {
      ref
          .read(touchReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    NoteEvent noteOn = NoteEvent(settings.channel, data.padNote,
        velocityProvider.velocity(data.yPercentage))
      ..noteOn(cc: settings.sendCC);

    touchBuffer.addNoteOn(CustomPointer(data.pointer, data.screenTouchPos),
        noteOn, data.screenSize);
  }

  void handlePan(NullableTouchAndScreenData data) {}

  void handleEndTouch(CustomPointer touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (settings.modReleaseTime == 0 && settings.noteReleaseTime == 0) {
      eventInBuffer.noteEvent.noteOff();
      releaseMPEChannel(eventInBuffer.noteEvent.channel);
      touchBuffer.remove(eventInBuffer);
    } else {
      if (settings.modReleaseTime == 0 && settings.noteReleaseTime > 0) {
        eventInBuffer.newPosition = eventInBuffer.origin; // mod to zero
      }
      touchReleaseBuffer.updateReleasedEvent(
          eventInBuffer); // instead of note off, event passed to release buffer
      touchBuffer.remove(eventInBuffer);
    }
  }

  void killAllNotes() {
    for (TouchEvent touch in touchBufsfer.buffer) {
      if (touch.noteEvent.isPlaying) touch.noteEvent.noteOff();
    }
    for (TouchEvent touch in touchReleaseBuffer.buffer) {
      if (touch.noteEvent.isPlaying) touch.noteEvent.noteOff();
    }
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
