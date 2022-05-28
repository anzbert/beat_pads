import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class MidiSender extends ChangeNotifier {
  Settings _settings;
  int _baseOctave;
  bool _disposed = false;
  bool preview;
  late PlayModeHandler playMode;

  /// Handles Touches and Midi Message sending
  MidiSender(this._settings, Size screenSize, {this.preview = false})
      : _baseOctave = _settings.baseOctave {
    if (_settings.playMode == PlayMode.mpe && preview == false) {
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
    if (_settings.playMode == PlayMode.mpe && preview == false) {
      MPEinitMessage(memberChannels: 0, upperZone: _settings.upperZone).send();
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
