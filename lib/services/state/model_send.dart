import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class MidiSender extends ChangeNotifier {
  Settings _settings;
  int _baseOctave;
  bool _disposed = false;
  bool preview;
  late PlayModeApi playMode;

  /// Handles Touches and Midi Message sending
  MidiSender(this._settings, Size screenSize, {this.preview = false})
      : _baseOctave = _settings.baseOctave {
    if (_settings.playMode == PlayMode.mpe && !preview) {
      MPEinitMessage(
              memberChannels: _settings.mpeMemberChannels,
              upperZone: _settings.upperZone)
          .send();
    }
    playMode = _settings.playMode
        .getPlayModeApi(_settings, screenSize, notifyListenersOfMidiSender);
  }

  /// Can be passed into Release Buffer Class
  void notifyListenersOfMidiSender() => notifyListeners();

  /// Handle all setting changes happening in the lifetime of the pad grid here.
  /// At the moment, only octave changes affect it directly.
  MidiSender update(Settings settings, Size size) {
    _settings = settings;
    _updateBaseOctave();
    return this;
  }

  /// Mark active TouchEvents as *dirty*, when the octave was changed
  /// preventing their position from being updated further in their lifetime.
  _updateBaseOctave() {
    if (_settings.baseOctave != _baseOctave) {
      playMode.markDirty();
      _baseOctave = _settings.baseOctave;
    }
  }

// ////////////////////////////////////////////////////////////////////////////////////////////////////

  /// Handles a new touch on a pad, creating and sending new noteOn events
  /// in the touch buffer
  void handleNewTouch(CustomPointer touch, int noteTapped) {
    playMode.handleNewTouch(touch, noteTapped);

    // int newChannel = _settings.playMode == PlayMode.mpe
    //     ? channelProvider.provideChannel(touchBuffer.buffer)
    //     : _settings.channel; // get new channel from generator

    // // reset note modulation before sending note
    // if (_settings.playMode == PlayMode.mpe) {
    //   if (_settings.modulation2D) {
    //     mpeMods.xMod.send(newChannel, noteTapped, 0);
    //     mpeMods.yMod.send(newChannel, noteTapped, 0);
    //   } else {
    //     mpeMods.rMod.send(newChannel, noteTapped, 0);
    //   }
    // } else if (_settings.playMode == PlayMode.polyAT) {
    //   polyATMod.send(newChannel, noteTapped, 0);
    // }

    // // create and send note
    // NoteEvent noteOn = NoteEvent(newChannel, noteTapped, _settings.velocity)
    //   ..noteOn(cc: _settings.playMode.singleChannel ? _settings.sendCC : false);

    // // remove from releasedNote buffer, if note was still pending there
    // if (_settings.sustainTimeUsable > 0) {
    //   releaseBuffer.removeNoteFromReleaseBuffer(noteTapped);
    // }

    // // add touch with note to buffer
    // touchBuffer.addNoteOn(touch, noteOn);
    // notifyListeners();
  }

  /// Handles sliding across pads in 'slide' mode
  void handlePan(CustomPointer touch, int? note) {
    playMode.handlePan(touch, note);
    // TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer) ??
    //     releaseBuffer.getByID(touch.pointer);

    // if (eventInBuffer == null || eventInBuffer.dirty) return;

    // if (_settings.playMode == PlayMode.slide) {
    //   // Turn note off:
    //   if (noteHovered != eventInBuffer.noteEvent.note &&
    //       eventInBuffer.noteEvent.noteOnMessage != null) {
    //     if (_settings.sustainTimeUsable == 0) {
    //       eventInBuffer.noteEvent.noteOff();
    //     } else {
    //       releaseBuffer.updateReleasedEvent(
    //         eventInBuffer,
    //       );
    //       eventInBuffer.noteEvent.noteOnMessage = null;
    //     }

    //     notifyListeners();
    //   }
    //   // Play new note:
    //   if (noteHovered != null &&
    //       eventInBuffer.noteEvent.noteOnMessage == null) {
    //     eventInBuffer.noteEvent = NoteEvent(
    //         _settings.channel, noteHovered, _settings.velocity)
    //       ..noteOn(
    //           cc: _settings.playMode.singleChannel ? _settings.sendCC : false);
    //     notifyListeners();
    //   }
    // }
  }

  /// Handles panning of the finger on the screen after the inital touch,
  /// as well as Midi Message sending behaviour in the different play modes
  // void handleModulate(CustomPointer touch, int? noteHovered) {
  // TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer) ??
  //     releaseBuffer.getByID(touch.pointer);

  // if (eventInBuffer == null || eventInBuffer.dirty) return;

  // eventInBuffer.updatePosition(touch.position);
  // notifyListeners(); // for circle drawing

  // // Poly AT
  // if (_settings.playMode == PlayMode.polyAT) {
  //   polyATMod.send(
  //     _settings.channel,
  //     eventInBuffer.noteEvent.note,
  //     eventInBuffer.radialChange(),
  //   );
  // }

  // // MPE
  // else if (_settings.playMode == PlayMode.mpe) {
  //   if (_settings.modulation2D) {
  //     mpeMods.xMod.send(
  //       eventInBuffer.noteEvent.channel,
  //       eventInBuffer.noteEvent.note,
  //       eventInBuffer.directionalChangeFromCenter().dx,
  //     );
  //     mpeMods.yMod.send(
  //       eventInBuffer.noteEvent.channel,
  //       eventInBuffer.noteEvent.note,
  //       eventInBuffer.directionalChangeFromCenter().dy,
  //     );
  //   } else {
  //     mpeMods.rMod.send(
  //       eventInBuffer.noteEvent.channel,
  //       eventInBuffer.noteEvent.note,
  //       eventInBuffer.radialChange(),
  //     );
  //   }
  // }
  // CC
  // else if (_settings.playMode == PlayMode.cc) {
  //   // not implemented yet
  // }
  // }

  /// Cleans up Touchevent, when contact with screen ends and the pointer is removed
  /// Adds released events to a buffer when auto-sustain is being used
  void handleEndTouch(CustomPointer touch) {
    playMode.handleEndTouch(touch);
    // TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    // if (eventInBuffer == null) return;

    // if (_settings.sustainTimeUsable == 0) {
    //   eventInBuffer.noteEvent.noteOff();

    //   if (_settings.playMode == PlayMode.mpe) {
    //     channelProvider.releaseChannel(eventInBuffer.noteEvent);
    //   }
    //   touchBuffer.remove(eventInBuffer); // events gets removed

    // } else {
    //   releaseBuffer
    //       .updateReleasedEvent(eventInBuffer); // event passed to release buffer
    //   touchBuffer.remove(eventInBuffer);
    // }

    // notifyListeners();
  }

  // DISPOSE:
  @override
  void dispose() {
    playMode.dispose();
    // if (_settings.playMode == PlayMode.mpe && preview == false) {
    //   MPEinitMessage(memberChannels: 0, upperZone: _settings.upperZone).send();
    // }
    // for (TouchEvent touch in touchBuffer.buffer) {
    //   touch.noteEvent.noteOff();
    // }
    // for (TouchEvent event in releaseBuffer.buffer) {
    //   event.noteEvent.noteOff();
    // }
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
