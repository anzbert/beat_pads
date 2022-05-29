import 'package:beat_pads/services/services.dart';

class PlayModeMPE extends PlayModeHandler {
  final SendMpe mpeMods;
  final MemberChannelProvider channelProvider;

  PlayModeMPE(super.settings, super.screenSize, super.notifyParent)
      : mpeMods = SendMpe(
          settings.mpe2DX.getMod(settings.mpePitchbendRange),
          settings.mpe2DY.getMod(settings.mpePitchbendRange),
          settings.mpe1DRadius.getMod(settings.mpePitchbendRange),
        ),
        channelProvider = MemberChannelProvider(
            settings.upperZone, settings.mpeMemberChannels);

  @override
  void releaseChannel(int channel) {
    channelProvider.releaseChannel(channel);
  }

  @override
  void handleNewTouch(CustomPointer touch, int noteTapped) {
    if (settings.modSustainTimeUsable > 0 ||
        settings.noteSustainTimeUsable > 0) {
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

    touchBuffer.addNoteOn(touch, noteOn);
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

  @override
  void handleEndTouch(CustomPointer touch) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    if (settings.modSustainTimeUsable == 0 &&
        settings.noteSustainTimeUsable == 0) {
      eventInBuffer.noteEvent.noteOff();

      channelProvider.releaseChannel(eventInBuffer.noteEvent.channel);
      touchBuffer.remove(eventInBuffer); // events gets removed
      notifyParent();
    } else {
      touchReleaseBuffer
          .updateReleasedEvent(eventInBuffer); // event passed to release buffer
      touchBuffer.remove(eventInBuffer);
    }
  }
}
