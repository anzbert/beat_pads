import 'package:beat_pads/services/services.dart';

class PlayModeNoSlide extends PlayModeHandler {
  PlayModeNoSlide(super.settings, super.notifyParent);
  // Uses default PlayModeHandler behaviour
}

abstract class PlayModeHandler {
  final SendSettings settings;
  final Function notifyParent;
  final VelocityProvider velocityProvider;

  final TouchBuffer touchBuffer;
  late TouchReleaseBuffer touchReleaseBuffer;

  PlayModeHandler(
    this.settings,
    this.notifyParent,
  )   : touchBuffer = TouchBuffer(settings),
        velocityProvider = VelocityProvider(settings, notifyParent) {
    touchReleaseBuffer = TouchReleaseBuffer(
      settings,
      releaseMPEChannel,
      notifyParent,
    );
  }

  void handleNewTouch(PadTouchAndScreenData data) {
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      touchReleaseBuffer.removeNoteFromReleaseBuffer(data.padNote);
    }

    NoteEvent noteOn = NoteEvent(settings.channel, data.padNote,
        velocityProvider.velocity(data.yPercentage))
      ..noteOn(cc: settings.sendCC);

    touchBuffer.addNoteOn(CustomPointer(data.pointer, data.screenTouchPos),
        noteOn, data.screenSize);
    notifyParent();
  }

  void handlePan(NullableTouchAndScreenData data) {}

  void handleEndTouch(CustomPointer touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (settings.modReleaseTime == 0 && settings.noteReleaseTime == 0) {
      eventInBuffer.noteEvent.noteOff();
      releaseMPEChannel(eventInBuffer.noteEvent.channel);
      touchBuffer.remove(eventInBuffer);

      notifyParent();
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
    for (TouchEvent touch in touchBuffer.buffer) {
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

  /// Returns if a given note is ON in any channel.
  /// Checks releasebuffer and active touchbuffer
  bool isNoteOn(int note) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (touch.noteEvent.note == note && touch.noteEvent.isPlaying) {
        return true;
      }
    }
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      for (TouchEvent event in touchReleaseBuffer.buffer) {
        if (event.noteEvent.note == note && event.noteEvent.isPlaying) {
          return true;
        }
      }
    }
    return false;
  }

  /// Does nothing, unless overridden in MPE
  void releaseMPEChannel(int channel) {}
}
