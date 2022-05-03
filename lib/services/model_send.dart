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

  /// Handles touches and Midi sending
  MidiSender(this._settings, Size screenSize, {this.preview = false})
      : _baseOctave = _settings.baseOctave,
        touchBuffer = TouchBuffer(_settings, screenSize) {
    if (_settings.playMode == PlayMode.mpe && preview == false) {
      MPEinitMessage(
              memberChannels: _settings.memberChannels,
              upperZone: _settings.upperZone)
          .send();
    }
  }

  /// Handle all setting changes happening in the lifetime of the pad grid here.
  /// At the moment only octave changes affect it.
  MidiSender update(Settings settings, Size size) {
    _settings = settings;
    _updateBaseOctave();
    return this;
  }

  _updateBaseOctave() {
    if (_settings.baseOctave != _baseOctave) {
      for (TouchEvent event in touchBuffer.buffer) {
        event.markDirty();
      }
      _baseOctave = _settings.baseOctave;
    }
  }

// ////////////////////////////////////////////////////////////////////////////////////////////////////

  /// check if a note is on in any channel, in releasebuffer and active touchbuffer
  bool isNoteOnInAnyChannel(int note) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (touch.noteEvent.note == note) return true;
    }
    if (_settings.sustainTimeUsable > 0) {
      for (NoteEvent event in releasedNoteBuffer) {
        if (event.note == note) return true;
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
    if (checkerRunning) return; // only one running instance possible !
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

/////////////////////////////////////////////////////////////////////////////////////////////////////
  // TOUCH HANDLING:

  /// Handles new Touches occuring
  void push(PointerEvent touch, int noteTapped) {
    NoteEvent noteOn =
        NoteEvent(_settings.memberChan, noteTapped, _settings.velocity)
          ..noteOn();

    // TODO reset existing pitch bends, etc ( see MPE spec!)

    touchBuffer.addNoteOn(touch, noteOn);
    notifyListeners();
  }

  /// Handles sliding of the finger after the inital touch
  void move(PointerEvent touch, int? noteHovered) {
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
            NoteEvent(_settings.memberChan, noteHovered, _settings.velocity)
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
      int newCC = (eventInBuffer.absoluteDirectionalChangeFromCenter().dx * 127)
          .toInt();
      if (newCC != eventInBuffer.modMapping.cc?.value) {
        eventInBuffer.modMapping.cc = CCMessage(
          channel: eventInBuffer.noteEvent.channel,
          controller: 74, // <- slide controller is #74
          value: newCC,
        )..send();
      }
    }
  }

  /// Cleans up Touchevent, when touch ends
  void lift(PointerEvent touch) {
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
