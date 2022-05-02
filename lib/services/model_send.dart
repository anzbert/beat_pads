import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';

class MidiSender extends ChangeNotifier {
  MidiSender(this._settings)
      : _baseOctave = _settings.baseOctave,
        touchBuffer = TouchBuffer(_settings.maxMPEControlDrawRadius) {
    if (_settings.playMode == PlayMode.mpe) {
      MPEinitMessage(
          memberChannels: _settings.memberChannels,
          upperZone: _settings.upperZone);
    }
  }

  Settings _settings;
  int _baseOctave;
  bool _disposed = false;
  final TouchBuffer touchBuffer;

  MidiSender update(Settings settings) {
    _settings = settings;
    // Handle all setting changes happening in the lifetime of the pad grid here.
    // At the moment only octave changes affect it.
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////

  // UTILITY
  double getEased(double value) {
    return Curves.easeIn.transform(value.clamp(0, 1));
  }

  // MIDI HANDLING:

  bool isNoteOnInAnyChannel(int note) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (touch.noteEvent.currentNoteOn == note) {
        return true;
      }
    }
    return false;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////
  // TOUCH HANDLING:
  push(PointerEvent touch, int noteTapped) {
    touchBuffer.addNoteOn(
        touch, noteTapped, _settings.memberChan, _settings.velocity);
    notifyListeners();
  }

  move(PointerEvent touch, int? noteHovered) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;
    if (eventInBuffer.dirty) return;

    eventInBuffer.updatePosition(touch.position);

    // SLIDE
    if (_settings.playMode == PlayMode.slide) {
      if (noteHovered != eventInBuffer.noteEvent.currentNoteOn &&
          eventInBuffer.noteEvent.currentNoteOn != null) {
        eventInBuffer.noteEvent.kill();
        notifyListeners();
      }
      if (noteHovered != null &&
          eventInBuffer.noteEvent.currentNoteOn == null) {
        eventInBuffer.noteEvent
            .revive(_settings.memberChan, noteHovered, _settings.velocity);
        notifyListeners();
      }
    }
    // Poly AT
    else if (_settings.playMode == PlayMode.polyAT) {
      eventInBuffer.updatePosition(touch.position);
      notifyListeners();
    }
    // CC
    else if (_settings.playMode == PlayMode.cc) {
    }
    // MPE
    else if (_settings.playMode == PlayMode.mpe) {}
  }

  lift(PointerEvent touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.noteEvent.kill();
    touchBuffer.remove(eventInBuffer);
    notifyListeners();
  }

  // DISPOSE:
  @override
  dispose() {
    if (_settings.playMode == PlayMode.mpe) {
      MPEinitMessage(memberChannels: 0, upperZone: _settings.upperZone);
    }
    for (TouchEvent touch in touchBuffer.buffer) {
      touch.noteEvent.kill();
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
//////////////////////////////////////////////////////////////////////////////
