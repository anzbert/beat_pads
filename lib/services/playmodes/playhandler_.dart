import 'package:beat_pads/services/services.dart';

class PlayModeNoSlide extends PlayModeHandler {
  PlayModeNoSlide(super.settings, super.notifyParent);
  // Uses default PlayModeHandler behaviour
}

abstract class PlayModeHandler {
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
  final SendSettings settings;
  final void Function() notifyParent;
  final VelocityProvider velocityProvider;

  final TouchBuffer touchBuffer;
  late TouchReleaseBuffer touchReleaseBuffer;

  void handleNewTouch(PadTouchAndScreenData data) {
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      touchReleaseBuffer.removeNoteFromReleaseBuffer(data.customPad.padValue);
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
    );
    notifyParent();
  }

  void handlePan(NullableTouchAndScreenData data) {}

  void handleEndTouch(CustomPointer touch) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
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
        eventInBuffer,
      ); // instead of note off, event passed to release buffer
      touchBuffer.remove(eventInBuffer);
    }
  }

  void killAllNotes() {
    for (final TouchEvent touch in touchBuffer.buffer) {
      if (touch.noteEvent.isPlaying) touch.noteEvent.noteOff();
    }
    for (final TouchEvent touch in touchReleaseBuffer.buffer) {
      if (touch.noteEvent.isPlaying) touch.noteEvent.noteOff();
    }
  }

  void markDirty() {
    for (final event in touchBuffer.buffer) {
      event.markDirty();
    }
    for (final event in touchReleaseBuffer.buffer) {
      event.markDirty();
    }
  }

  /// Returns the velocity if a given note is ON in any channel.
  /// Checks releasebuffer and active touchbuffer
  int isNoteOn(int note) {
    for (final TouchEvent touch in touchBuffer.buffer) {
      if (touch.noteEvent.note == note && touch.noteEvent.isPlaying) {
        return touch.noteEvent.velocity;
        // return true;
      }
    }
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      for (final TouchEvent event in touchReleaseBuffer.buffer) {
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
