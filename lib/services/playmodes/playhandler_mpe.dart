import 'package:beat_pads/services/services.dart';

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
  void releaseMPEChannel(int channel) {
    channelProvider.releaseMPEChannel(channel);
  }

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    // remove note if it is still playing
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      touchReleaseBuffer.removeNoteFromReleaseBuffer(data.padNote);
    }

    int newChannel = channelProvider.provideChannel([
      ...touchBuffer.buffer,
      ...touchReleaseBuffer.buffer
    ]); // get new channel from generator

    if (settings.modulation2D) {
      mpeMods.xMod.send(newChannel, data.padNote, 0);
      mpeMods.yMod.send(newChannel, data.padNote, 0);
    } else {
      mpeMods.rMod.send(newChannel, data.padNote, 0);
    }

    double percentage = data.padTouchPos.dy / data.padDimensions.height;

    NoteEvent noteOn = NoteEvent(
        newChannel, data.padNote, velocityProvider.velocity(percentage))
      ..noteOn(cc: false);

    touchBuffer.addNoteOn(CustomPointer(data.pointer, data.screenTouchPos),
        noteOn, data.screenSize);
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
