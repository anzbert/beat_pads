import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MidiSender extends ChangeNotifier {
  final TouchBuffer touchBuffer;
  Settings _settings;
  int _baseOctave;
  bool _disposed = false;
  List<NoteEvent> releasedNoteBuffer = [];
  bool checkerRunning = false;
  bool preview;

  /// Handles Touches and Midi Message sending
  MidiSender(this._settings, Size screenSize, {this.preview = false})
      : _baseOctave = _settings.baseOctave,
        touchBuffer = TouchBuffer(_settings, screenSize) {
    if (_settings.playMode == PlayMode.mpe && preview == false) {
      MPEinitMessage(
              memberChannels: _settings.totalMemberChannels,
              upperZone: _settings.upperZone)
          .send();
    }
  }

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
            releasedNoteBuffer.removeAt(i);
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
    NoteEvent noteOn =
        NoteEvent(_settings.memberChannel, noteTapped, _settings.velocity)
          ..noteOn();

    // TODO reset existing pitch bends, etc ( see MPE spec!)

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
        eventInBuffer.noteEvent =
            NoteEvent(_settings.memberChannel, noteHovered, _settings.velocity)
              ..noteOn();
        notifyListeners();
      }
    }

    // Poly AT
    else if (_settings.playMode == PlayMode.polyAT) {
      int newPressure = (eventInBuffer.radialChange() * 127).toInt();

      if (eventInBuffer.modMapping.polyAT?.pressure != newPressure) {
        eventInBuffer.modMapping.polyAT = PolyATMessage(
          channel: _settings.channel,
          note: eventInBuffer.noteEvent.note,
          pressure: (newPressure).toInt(),
        )..send();
      }
    }

    // CC
    else if (_settings.playMode == PlayMode.cc) {
      int newCC = (eventInBuffer.radialChange() * 127).toInt();

      if (eventInBuffer.modMapping.polyAT?.pressure != newCC) {
        eventInBuffer.modMapping.cc = CCMessage(
          channel: _settings.channel,
          controller: eventInBuffer.noteEvent.note,
          value: (eventInBuffer.radialChange() * 127).toInt(),
        )..send();
      }
    }
    // MPE
    else if (_settings.playMode == PlayMode.mpe) {
      // Y AXIS:
      double newPB = (eventInBuffer.directionalChangeFromCenter().dy);

      if (newPB != eventInBuffer.modMapping.pitchBend?.bend) {
        eventInBuffer.modMapping.pitchBend = PitchBendMessage(
          channel: eventInBuffer.noteEvent.channel,
          bend: newPB,
        )..send();
      }

      // X AXIS:
      int newCC =
          (eventInBuffer.directionalChangeFromCenter().dx.abs() * 127).toInt();
      if (newCC != eventInBuffer.modMapping.cc?.value) {
        eventInBuffer.modMapping.cc = CCMessage(
          channel: eventInBuffer.noteEvent.channel,
          controller: 74, // <- slide controller is #74
          value: newCC,
        )..send();
      }
    }
  }

  /// Cleans up Touchevent, when contact with screen ends and the pointer is removed
  /// Adds released events to a buffer when auto-sustain is being used
  void handleEndTouch(PointerEvent touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (_settings.sustainTimeUsable <= 0) {
      eventInBuffer.noteEvent.noteOff();
      touchBuffer.remove(eventInBuffer);
    } else {
      updateReleasedEvent(eventInBuffer.noteEvent);
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
