import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final senderProvider = ChangeNotifierProvider.autoDispose<MidiSender>(
  (ref) => MidiSender(
    ref.read(settingsProvider.notifier), // get settings once on creation
  ),
);

class MidiSender extends ChangeNotifier {
  final Settings _settings;
  late PlayModeHandler playMode;

  bool _disposed = false;

  /// Handles Touches and Midi Message sending
  MidiSender(this._settings) {
    // print("creating sender");
    playMode = _settings.playMode
        .getPlayModeApi(_settings, notifyListenersOfMidiSender);

    if (_settings.playMode == PlayMode.mpe) {
      MPEinitMessage(
              memberChannels: _settings.mpeMemberChannels,
              upperZone: _settings.upperZone)
          .send();
    }
  }

  /// Can be passed into sub-Classes
  void notifyListenersOfMidiSender() => notifyListeners();

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    // print("disposing sender");
    if (_settings.playMode == PlayMode.mpe) {
      MPEinitMessage(memberChannels: 0, upperZone: _settings.upperZone).send();
      playMode.killAllNotes();
      _disposed = true;
    }
    super.dispose();
  }

  /// Mark active TouchEvents as *dirty*, when the octave was changed
  /// preventing their position from being updated further in their lifetime.
  void markEventsDirty() {
    playMode.markDirty();
  }

// //////////////////////////////////////////////////////////////////////////////////////////

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
}
