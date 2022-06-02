import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class MidiSender extends ChangeNotifier {
  final Settings _settings;
  int _baseOctave;
  bool _disposed = false;
  late PlayModeHandler playMode;

  /// Handles Touches and Midi Message sending
  MidiSender(this._settings) : _baseOctave = _settings.baseOctave {
    playMode = _settings.playMode
        .getPlayModeApi(_settings, notifyListenersOfMidiSender);
  }

  /// Can be passed into sub-Classes
  void notifyListenersOfMidiSender() => notifyListeners();

  /// Mark active TouchEvents as *dirty*, when the octave was changed
  /// preventing their position from being updated further in their lifetime.
  updateBaseOctave(int newBaseOctave) {
    // TODO this wont work with riverpod ????!!!
    if (newBaseOctave != _baseOctave) {
      playMode.markDirty();
      _baseOctave = newBaseOctave;
    }
  }

// ////////////////////////////////////////////////////////////////////////////////////////////////////

  /// Handles a new touch on a pad, creating and sending new noteOn events
  /// in the touch buffer
  void handleNewTouch(CustomPointer touch, int noteTapped, Size screenSize) {
    playMode.handleNewTouch(touch, noteTapped, screenSize);
  }

  /// Handles sliding across pads in 'slide' mode
  void handlePan(CustomPointer touch, int? note) {
    playMode.handlePan(touch, note);
  }

  /// Cleans up Touchevent, when contact with screen ends and the pointer is removed
  /// Adds released events to a buffer when auto-sustain is being used
  void handleEndTouch(CustomPointer touch) {
    playMode.handleEndTouch(touch);
  }

  // DISPOSE:
  @override
  void dispose() {
    playMode.dispose();

    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }
}
