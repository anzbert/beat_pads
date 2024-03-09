import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Sending logic still uses ChangeNotifier. Could be refactored for Riverpod
// for improved clarity and expandability.
// TODO Refactor: Replace outdated ChangeNotifier with new Riverpod Notifiers. Extract midi send system parts into seperate providers (Time consuming)

class SendSettings {
  /// A data object which holds all the settings required for sending midi
  SendSettings(
    this.channel,
    this.modulationRadius,
    this.modulationDeadZone,
    this.mpeMemberChannels,
    this.playMode,
    // ignore: avoid_positional_boolean_parameters
    this.zone,
    this.sendCC,
    this.noteReleaseTime,
    this.modReleaseTime,
    this.mpe1DRadius,
    this.mpe2DX,
    this.mpe2DY,
    this.mpePitchbendRange,
    this.modulation2D,
    this.velocityRange,
    this.velocity,
    this.velocityCenter,
    this.velocityMode,
  );
  final PlayMode playMode;
  final int channel;
  final double modulationRadius;
  final double modulationDeadZone;
  final int mpeMemberChannels;
  final bool zone;
  final bool sendCC;
  final int noteReleaseTime;
  final int modReleaseTime;
  final MPEmods mpe1DRadius;
  final MPEmods mpe2DX;
  final MPEmods mpe2DY;
  final int mpePitchbendRange;
  final bool modulation2D;
  final int velocityRange;
  final int velocity;
  final double velocityCenter;
  final VelocityMode velocityMode;
}

/// Reactive state of the current send-settings to be used in legacy changenotifier
final combinedSettings = Provider.autoDispose<SendSettings>((ref) {
  return SendSettings(
    ref.watch(channelUsableProv),
    ref.watch(modulationRadiusProv),
    ref.watch(modulationDeadZoneProv),
    ref.watch(mpeMemberChannelsProv),
    ref.watch(playModeProv),
    ref.watch(zoneProv),
    ref.watch(sendCCProv),
    ref.watch(noteReleaseUsable),
    ref.watch(modReleaseUsable),
    ref.watch(mpe1DRadiusProv),
    ref.watch(mpe2DXProv),
    ref.watch(mpe2DYProv),
    ref.watch(mpePitchbendRangeProv),
    ref.watch(modulation2DProv),
    ref.watch(velocityRangeProv),
    ref.watch(velocityProv),
    ref.watch(velocityCenterProv),
    ref.watch(velocityModeProv),
  );
});

/// The usable sender object, which refreshes when any relevant setting changes
final senderProvider = ChangeNotifierProvider.autoDispose<MidiSender>((ref) {
  return MidiSender(ref.watch(combinedSettings));
});

class MidiSender extends ChangeNotifier {
  /// Handles Touches and Midi Message sending
  MidiSender(this.settings) {
    playModeHandler = settings.playMode
        .getPlayModeApi(settings, _notifyListenersOfMidiSender);

    if (settings.playMode == PlayMode.mpe) {
      MPEinitMessage(
        memberChannels: settings.mpeMemberChannels,
        upperZone: settings.zone,
      ).send();
    }
  }
  late PlayModeHandler playModeHandler;
  final SendSettings settings;

  bool _disposed = false;

  /// Can be passed into sub-Classes
  void _notifyListenersOfMidiSender() => notifyListeners();

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    // print("disposing sender");
    if (settings.playMode == PlayMode.mpe) {
      MPEinitMessage(memberChannels: 0, upperZone: settings.zone).send();
      playModeHandler.killAllNotes();
    }
    _disposed = true;
    super.dispose();
  }

  /// Mark active TouchEvents as *dirty*, when the octave was changed
  /// preventing their position from being updated further in their lifetime.
  void markEventsDirty() {
    playModeHandler.markDirty();
  }

// //////////////////////////////////////////////////////////////////////////////////////////

  /// Handles a new touch on a pad, creating and sending new noteOn events
  /// in the touch buffer
  void handleNewTouch(PadTouchAndScreenData data) {
    playModeHandler.handleNewTouch(data);
  }

  /// Handles sliding across pads in 'slide' mode
  void handlePan(NullableTouchAndScreenData data) {
    playModeHandler.handlePan(data);
  }

  /// Cleans up Touchevent, when contact with screen ends and the pointer is removed
  /// Adds released events to a buffer when auto-sustain is being used
  void handleEndTouch(CustomPointer touch) {
    playModeHandler.handleEndTouch(touch);
  }
}
