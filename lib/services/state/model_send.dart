import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';

class MidiSender extends ChangeNotifier {
  final TouchBuffer touchBuffer;
  Settings _settings;
  int _baseOctave;
  bool _disposed = false;
  List<NoteEvent> releasedNoteBuffer = [];
  bool checkerRunning = false;
  bool preview;
  final ModPolyAfterTouch1D polyATMod;
  SendMpe mpeMods;

  /// Handles Touches and Midi Message sending
  MidiSender(this._settings, Size screenSize, {this.preview = false})
      : _baseOctave = _settings.baseOctave,
        touchBuffer = TouchBuffer(_settings, screenSize),
        polyATMod = ModPolyAfterTouch1D(),
        mpeMods = SendMpe(
          _settings.mpe2DX.getMod(_settings.mpePitchbendRange),
          _settings.mpe2DY.getMod(_settings.mpePitchbendRange),
          _settings.mpe1DRadius.getMod(_settings.mpePitchbendRange),
        ) {
    if (_settings.playMode == PlayMode.mpe && !preview) {
      MPEinitMessage(
              memberChannels: _settings.mpeMemberChannels,
              upperZone: _settings.upperZone)
          .send();
    }
  }

  /// Handle all setting changes happening in the lifetime of the pad grid here.
  /// At the moment, only octave changes affect it directly.
  MidiSender update(Settings settings, Size size) {
    _settings = settings;
    _updateBaseOctave();
    mpeMods = SendMpe(
      _settings.mpe2DX.getMod(_settings.mpePitchbendRange),
      _settings.mpe2DY.getMod(_settings.mpePitchbendRange),
      _settings.mpe1DRadius.getMod(_settings.mpePitchbendRange),
    );
    return this;
  }

  /// Mark active TouchEvents as *dirty*, when the octave was changed
  /// preventing their position from being updated further in their lifetime.
  _updateBaseOctave() {
    if (_settings.baseOctave != _baseOctave) {
      for (TouchEvent event in touchBuffer.buffer) {
        event.markDirty();
      }
      _baseOctave = _settings.baseOctave;
    }
  }

// ////////////////////////////////////////////////////////////////////////////////////////////////////

  /// Returns if a given note is ON in any channel, or, if provided, in a specific channel.
  /// Checks releasebuffer and active touchbuffer
  bool isNoteOn(int note, [int? channel]) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (channel == null && touch.noteEvent.note == note) return true;
      if (channel == channel && touch.noteEvent.note == note) return true;
    }
    if (_settings.sustainTimeUsable > 0) {
      for (NoteEvent event in releasedNoteBuffer) {
        if (channel == null && event.note == note) return true;
        if (channel == channel && event.note == note) return true;
      }
    }
    return false;
  }

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  void updateReleasedEvent(NoteEvent event) {
    int index = releasedNoteBuffer.indexWhere((element) =>
        element.note == event.note && element.channel == event.channel);

    if (index >= 0) {
      releasedNoteBuffer[index].updateReleaseTime(); // update time
    } else {
      event.updateReleaseTime();
      releasedNoteBuffer.add(event); // or add to buffer
    }
    if (releasedNoteBuffer.isNotEmpty) checkReleasedEvents();
  }

  /// Async function, which checks for expiry of the auto-sustain on all released notes
  void checkReleasedEvents() async {
    if (checkerRunning) return; // only one running instance possible!
    checkerRunning = true;

    while (releasedNoteBuffer.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 5), () {
        for (int i = 0; i < releasedNoteBuffer.length; i++) {
          if (DateTime.now().millisecondsSinceEpoch -
                  releasedNoteBuffer[i].releaseTime >
              _settings.sustainTimeUsable) {
            releasedNoteBuffer[i].noteOff();
            releasedNoteBuffer.removeAt(i); // TODO event gets removed here!
            notifyListeners();
          }
        }
      });
    }

    checkerRunning = false;
  }

  /// Handles a new touch on a pad, creating and sending new noteOn events
  /// in the touch buffer
  void handleNewTouch(PointerEvent touch, int noteTapped) {
    int newChannel = _settings.memberChannel; // get new channel from generator

    // reset note modulation before sending note
    if (_settings.playMode == PlayMode.mpe) {
      if (_settings.modulation2D) {
        mpeMods.xMod.send(newChannel, noteTapped, 0);
        mpeMods.yMod.send(newChannel, noteTapped, 0);
      } else {
        mpeMods.rMod.send(newChannel, noteTapped, 0);
      }
    } else if (_settings.playMode == PlayMode.polyAT) {
      polyATMod.send(newChannel, noteTapped, 0);
    }

    // create and send note
    NoteEvent noteOn = NoteEvent(newChannel, noteTapped, _settings.velocity)
      ..noteOn(cc: _settings.playMode.singleChannel ? _settings.sendCC : false);

    // add touch with note to buffer
    touchBuffer.addNoteOn(touch, noteOn);
    notifyListeners();
  }

  /// Handles panning of the finger on the screen after the inital touch,
  /// as well as Midi Message sending behaviour in the different play modes
  void handlePan(PointerEvent touch, int? noteHovered) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null || eventInBuffer.dirty) return;

    eventInBuffer.updatePosition(touch.position);
    notifyListeners(); // for circle drawing

    // SLIDE
    if (_settings.playMode == PlayMode.slide) {
      // Turn note off:
      if (noteHovered != eventInBuffer.noteEvent.note &&
          eventInBuffer.noteEvent.noteOnMessage != null) {
        if (_settings.sustainTimeUsable == 0) {
          eventInBuffer.noteEvent.noteOff();
        } else {
          updateReleasedEvent(NoteEvent(
            eventInBuffer.noteEvent.channel,
            eventInBuffer.noteEvent.note,
            _settings.velocity,
          ));
          eventInBuffer.noteEvent.noteOnMessage = null;
        }

        notifyListeners();
      }
      // Play new note:
      if (noteHovered != null &&
          eventInBuffer.noteEvent.noteOnMessage == null) {
        eventInBuffer.noteEvent = NoteEvent(
            _settings.memberChannel, noteHovered, _settings.velocity)
          ..noteOn(
              cc: _settings.playMode.singleChannel ? _settings.sendCC : false);
        notifyListeners();
      }
    }

    // Poly AT
    else if (_settings.playMode == PlayMode.polyAT) {
      polyATMod.send(
        _settings.channel,
        eventInBuffer.noteEvent.note,
        eventInBuffer.radialChange(),
      );
    }

    // MPE
    else if (_settings.playMode == PlayMode.mpe) {
      if (_settings.modulation2D) {
        mpeMods.xMod.send(
          eventInBuffer.noteEvent.channel,
          eventInBuffer.noteEvent.note,
          eventInBuffer.directionalChangeFromCenter().dx,
        );
        mpeMods.yMod.send(
          eventInBuffer.noteEvent.channel,
          eventInBuffer.noteEvent.note,
          eventInBuffer.directionalChangeFromCenter().dy,
        );
      } else {
        mpeMods.rMod.send(
          eventInBuffer.noteEvent.channel,
          eventInBuffer.noteEvent.note,
          eventInBuffer.radialChange(),
        );
      }
    }
    // CC
    // else if (_settings.playMode == PlayMode.cc) {
    //   // not implemented yet
    // }
  }

  /// Cleans up Touchevent, when contact with screen ends and the pointer is removed
  /// Adds released events to a buffer when auto-sustain is being used
  void handleEndTouch(PointerEvent touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (_settings.sustainTimeUsable == 0) {
      eventInBuffer.noteEvent.noteOff();
      touchBuffer.remove(eventInBuffer); // events gets removed

    } else {
      updateReleasedEvent(
          eventInBuffer.noteEvent); // event passed to release buffer
      touchBuffer.remove(eventInBuffer);
    }

    notifyListeners();
  }

  // DISPOSE:
  @override
  void dispose() {
    if (_settings.playMode == PlayMode.mpe && preview == false) {
      MPEinitMessage(memberChannels: 0, upperZone: _settings.upperZone).send();
    }
    for (TouchEvent touch in touchBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
    for (NoteEvent event in releasedNoteBuffer) {
      event.noteOff();
    }
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
