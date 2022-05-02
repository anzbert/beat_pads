import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MidiSender extends ChangeNotifier {
  final TouchBuffer touchBuffer;
  Settings _settings;
  int _baseOctave;
  bool _disposed = false;
  List<NoteEvent> releasedEvents = [];
  bool checkerRunning = false;

  /// Handles touches and Midi sending
  MidiSender(this._settings)
      : _baseOctave = _settings.baseOctave,
        touchBuffer = TouchBuffer(_settings) {
    if (_settings.playMode == PlayMode.mpe) {
      MPEinitMessage(
          memberChannels: _settings.memberChannels,
          upperZone: _settings.upperZone);
    }
  }

  /// Handle all setting changes happening in the lifetime of the pad grid here.
  /// At the moment only octave changes affect it.
  MidiSender update(Settings settings) {
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

//////////////////////////////////////////////////////////////////////////////////////////////////////
  bool isNoteOnInAnyChannel(int note) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (touch.noteEvent.currentNoteOn == note) {
        return true;
      }
    }
    if (_settings.sustainTimeUsable > 0) {
      for (NoteEvent event in releasedEvents) {
        if (event.currentNoteOn == note) {
          return true;
        }
      }
    }
    return false;
  }

  bool isNoteOnInChannel(int note, int channel) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (touch.noteEvent.currentNoteOn == note &&
          touch.noteEvent.channel == channel) {
        return true;
      }
    }
    if (_settings.sustainTimeUsable > 0) {
      for (NoteEvent event in releasedEvents) {
        if (event.currentNoteOn == note && event.channel == channel) {
          return true;
        }
      }
    }

    return false;
  }

  void updateReleasedEvents(NoteEvent event) {
    int index = releasedEvents.indexWhere((element) =>
        element.currentNoteOn == event.currentNoteOn &&
        element.channel == event.channel);

    if (index >= 0) {
      releasedEvents[index].updateReleaseTime();
    } else {
      event.updateReleaseTime();
      releasedEvents.add(event);
    }
    if (releasedEvents.isNotEmpty) checkReleasedEvents();
  }

  void checkReleasedEvents() async {
    if (checkerRunning) return;
    checkerRunning = true;

    while (releasedEvents.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 5), () {
        for (int i = 0; i < releasedEvents.length; i++) {
          if (DateTime.now().millisecondsSinceEpoch -
                  releasedEvents[i].releaseTime >
              _settings.sustainTimeUsable) {
            releasedEvents[i].noteOff();
            releasedEvents.removeAt(i);
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
        NoteEvent(_settings.memberChan, noteTapped, _settings.velocity);
    touchBuffer.addNoteOn(touch, noteOn);
    notifyListeners();
  }

  /// Handles sliding of the finger after the inital touch
  void move(PointerEvent touch, int? noteHovered) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null || eventInBuffer.dirty) return;

    eventInBuffer.updatePosition(touch.position);
    if (_settings.playMode.afterTouch) notifyListeners(); // for circle drawing

    // SLIDE
    if (_settings.playMode == PlayMode.slide) {
      // Turn note off:
      if (noteHovered != eventInBuffer.noteEvent.currentNoteOn &&
          eventInBuffer.noteEvent.currentNoteOn != null) {
        if (_settings.sustainTimeUsable <= 0) {
          eventInBuffer.noteEvent.noteOff();
        } else {
          updateReleasedEvents(eventInBuffer.noteEvent);
        }

        notifyListeners();
      }
      // Play new note:
      if (noteHovered != null &&
          eventInBuffer.noteEvent.currentNoteOn == null) {
        eventInBuffer.noteEvent =
            NoteEvent(_settings.memberChan, noteHovered, _settings.velocity);
        notifyListeners();
      }
    }

    // TODO send directly or add to noteevent??

    // Poly AT
    else if (_settings.playMode == PlayMode.polyAT) {
      int newPressure = (eventInBuffer.radialChange() * 127).toInt();

      if (eventInBuffer.modMapping.polyAT?.pressure != newPressure) {
        eventInBuffer.modMapping.polyAT = PolyATMessage(
          channel: _settings.channel,
          note: eventInBuffer.noteEvent.currentNoteOn!,
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
          controller: eventInBuffer.noteEvent.currentNoteOn!,
          value: (eventInBuffer.radialChange() * 127).toInt(),
        )..send();
      }
    }
    // MPE
    else if (_settings.playMode == PlayMode.mpe) {
      // Y AXIS:
      PitchBendMessage(
              channel: eventInBuffer.noteEvent.channel,
              bend:
                  (eventInBuffer.directionalChangeFromCartesianOrigin().dy * 2 -
                      1))
          .send();

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
      updateReleasedEvents(eventInBuffer.noteEvent);
      touchBuffer.remove(eventInBuffer);
    }
    notifyListeners();
  }

  // DISPOSE:
  @override
  void dispose() {
    if (_settings.playMode == PlayMode.mpe) {
      MPEinitMessage(memberChannels: 0, upperZone: _settings.upperZone);
    }
    for (TouchEvent touch in touchBuffer.buffer) {
      touch.noteEvent.noteOff();
    }
    for (NoteEvent event in releasedEvents) {
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
