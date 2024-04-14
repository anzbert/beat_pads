import 'package:beat_pads/services/services.dart';

class PlayModeMPE extends PlayModeHandler {
  PlayModeMPE(super.settings, super.notifyParent)
      : mpeMods = SendMpe(
          settings.mpe2DX.getMod(settings.mpePitchbendRange),
          settings.mpe2DY.getMod(settings.mpePitchbendRange),
          settings.mpe1DRadius.getMod(settings.mpePitchbendRange),
        ),
        channelProvider = MemberChannelProvider(
          settings.mpeMemberChannels,
          upperZone: settings.zone,
        );
  final SendMpe mpeMods;
  final MemberChannelProvider channelProvider;

  /// Release channel in MPE channel provider
  @override
  void releaseMPEChannel(int channel) {
    channelProvider.releaseMPEChannel(channel);
  }

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    // remove note if it is still playing
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      touchReleaseBuffer.removeNoteFromReleaseBuffer(data.customPad.padValue);
    }

    final int newChannel = channelProvider.provideChannel([
      ...touchBuffer.buffer,
      ...touchReleaseBuffer.buffer,
    ]); // get new channel from generator

    if (settings.modulation2D) {
      mpeMods.xMod.send(newChannel, data.customPad.padValue, 0);
      mpeMods.yMod.send(newChannel, data.customPad.padValue, 0);
    } else {
      mpeMods.rMod.send(newChannel, data.customPad.padValue, 0);
    }

    final NoteEvent noteOn = NoteEvent(
      newChannel,
      data.customPad,
      velocityProvider.velocity(data.yPercentage),
    )..noteOn();

    touchBuffer.addNoteOn(
      CustomPointer(data.pointer, data.screenTouchPos),
      noteOn,
      data.screenSize,
      data.padBox,
      data.xPercentage,
      data.yPercentage,
    );
    notifyParent();
  }

  @override
  // void handlePan(CustomPointer touch, int? note) {
  void handlePan(NullableTouchAndScreenData data) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer) ??
        touchReleaseBuffer.getByID(data.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.updatePosition(data.screenTouchPos);
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
