import 'package:beat_pads/services/services.dart';

class PlayModeMPE extends PlayModeHandler {
  PlayModeMPE(super.settings, super.notifyParent)
      : mpeMods = SendMod(
          settings.mpe2DX.getMod(settings.mpePitchbendRange),
          settings.mpe2DY.getMod(settings.mpePitchbendRange),
          settings.mpe1DRadius.getMod(settings.mpePitchbendRange),
        ),
        channelProvider = MemberChannelProvider(
          settings.mpeMemberChannels,
          upperZone: settings.zone,
        );
  final SendMod mpeMods;
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
      mpeMods.xMod.send(
        0,
        newChannel,
        data.customPad.padValue,
      );
      mpeMods.yMod.send(
        0,
        newChannel,
        data.customPad.padValue,
      );
    } else {
      mpeMods.rMod.send(
        0,
        newChannel,
        data.customPad.padValue,
      );
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
        eventInBuffer.directionalChangeFromCenter().dx,
        eventInBuffer.noteEvent.channel,
        eventInBuffer.noteEvent.note,
      );
      mpeMods.yMod.send(
        eventInBuffer.directionalChangeFromCenter().dy,
        eventInBuffer.noteEvent.channel,
        eventInBuffer.noteEvent.note,
      );
    } else {
      mpeMods.rMod.send(
        eventInBuffer.radialChange(),
        eventInBuffer.noteEvent.channel,
        eventInBuffer.noteEvent.note,
      );
    }
  }
}
