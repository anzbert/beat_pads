import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

enum PlayMode {
  slide("Sliding"),
  noSlide("No Sliding"),
  polyAT("Poly Aftertouch"),
  mpe("MPE");

  const PlayMode(this.title);
  final String title;

  static PlayMode? fromName(String key) {
    for (PlayMode mode in PlayMode.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  bool get modulatable {
    switch (this) {
      case PlayMode.polyAT:
        return true;
      case PlayMode.mpe:
        return true;
      default:
        return false;
    }
  }

  bool get singleChannel {
    if (this == PlayMode.mpe) return false;
    return true;
  }

  bool get multiChannel {
    if (this == PlayMode.mpe) return true;
    return false;
  }

  PlayModeApi getPlayModeApi(
      Settings settings, Size screenSize, Function notifyParent) {
    switch (this) {
      case PlayMode.mpe:
        return PlayModeMPE(settings, screenSize, notifyParent);
      case PlayMode.noSlide:
        return PlayModeNoSlide(settings, screenSize, notifyParent);
      case PlayMode.slide:
        return PlayModeSlide(settings, screenSize, notifyParent);
      case PlayMode.polyAT:
        return PlayModePolyAT(settings, screenSize, notifyParent);
    }
  }
}

abstract class PlayModeApi {
  final Settings settings;
  final Function notifyParent;

  final TouchBuffer touchBuffer;
  final ReleaseBuffer releaseBuffer;

  PlayModeApi(this.settings, Size screenSize, this.notifyParent)
      : touchBuffer = TouchBuffer(settings, screenSize),
        releaseBuffer = ReleaseBuffer(
          settings,
          MemberChannelProvider(settings.upperZone, settings.mpeMemberChannels),
          notifyParent,
        );

  void handleNewTouch(CustomPointer touch, int noteTapped);
  void handlePan(CustomPointer touch, int? note);
  void handleEndTouch(CustomPointer touch);
  void dispose();

  void markDirty() {
    for (var event in touchBuffer.buffer) {
      event.markDirty();
    }
  }

  /// Returns if a given note is ON in any channel, or, if provided, in a specific channel.
  /// Checks releasebuffer and active touchbuffer
  bool isNoteOn(int note, [int? channel]) {
    for (TouchEvent touch in touchBuffer.buffer) {
      if (channel == null && touch.noteEvent.note == note) return true;
      if (channel == channel && touch.noteEvent.note == note) return true;
    }
    if (settings.sustainTimeUsable > 0) {
      for (TouchEvent event in releaseBuffer.buffer) {
        if (channel == null && event.noteEvent.note == note) return true;
        if (channel == channel && event.noteEvent.note == note) return true;
      }
    }
    return false;
  }
}
