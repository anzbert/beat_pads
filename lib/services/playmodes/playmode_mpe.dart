import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class PlayModeMPE extends PlayModeHandler {
  final SendMpe mpeMods;
  final MemberChannelProvider channelProvider;

  PlayModeMPE(super.settings, super.notifyParent)
      : mpeMods = SendMpe(
          settings.mpe2DX.getMod(settings.mpePitchbendRange),
          settings.mpe2DY.getMod(settings.mpePitchbendRange),
          settings.mpe1DRadius.getMod(settings.mpePitchbendRange),
        ),
        channelProvider =
            MemberChannelProvider(settings.zone, settings.mpeMemberChannels);

  /// Release channel in MPE channel provider
  @override
  void releaseChannel(int channel) {
    channelProvider.releaseChannel(channel);
  }

  @override
  void handleNewTouch(CustomPointer touch, int noteTapped, Size screenSize) {
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      touchReleaseBuffer.removeNoteFromReleaseBuffer(noteTapped);
    }

    int newChannel = channelProvider
        .provideChannel(touchBuffer.buffer); // get new channel from generator

    if (settings.modulation2D) {
      mpeMods.xMod.send(newChannel, noteTapped, 0);
      mpeMods.yMod.send(newChannel, noteTapped, 0);
    } else {
      mpeMods.rMod.send(newChannel, noteTapped, 0);
    }

    NoteEvent noteOn =
        NoteEvent(newChannel, noteTapped, velocityProvider.velocity)
          ..noteOn(cc: false);

    touchBuffer.addNoteOn(touch, noteOn, screenSize);
    notifyParent();
  }

  @override
  void handlePan(CustomPointer touch, int? note) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer) ??
        touchReleaseBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.updatePosition(touch.position);
    notifyParent(); // for circle drawing

    if (settings.modulation2D) {
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
}
