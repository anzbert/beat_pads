import 'package:beat_pads/services/services.dart';

class PlayModeMPE extends PlayModeHandler {
  final SendMpe mpeMods;
  final MemberChannelProvider channelProvider;

  PlayModeMPE(super.ref)
      : mpeMods = SendMpe(
          ref.read(mpe2DXProv).getMod(ref.read(mpePitchbendRangeProv)),
          ref.read(mpe2DYProv).getMod(ref.read(mpePitchbendRangeProv)),
          ref.read(mpe1DRadiusProv).getMod(ref.read(mpePitchbendRangeProv)),
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
    if (ref.read(modReleaseUsable) > 0 || ref.read(noteReleaseUsable) > 0) {
      ref
          .read(noteReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    int newChannel = channelProvider.provideChannel([
      ...ref.read(touchBuffer),
      ...ref.read(touchReleaseBuffer)
    ]); // get new channel from generator

    if (ref.read(modulation2DProv)) {
      mpeMods.xMod.send(newChannel, data.padNote, 0);
      mpeMods.yMod.send(newChannel, data.padNote, 0);
    } else {
      mpeMods.rMod.send(newChannel, data.padNote, 0);
    }

    NoteEvent noteOn = NoteEvent(newChannel, data.padNote,
        ref.read(velocitySliderValueProv.notifier).velocity(data.yPercentage))
      ..noteOn(cc: false);

    ref.read(touchBuffer.notifier).addNoteOn(
        CustomPointer(data.pointer, data.screenTouchPos),
        noteOn,
        data.screenSize);
    // notifyParent();
  }

  @override
  // void handlePan(CustomPointer touch, int? note) {
  void handlePan(NullableTouchAndScreenData data) {
    TouchEvent? eventInBuffer =
        ref.read(touchBuffer.notifier).getByID(data.pointer) ??
            ref.read(touchReleaseBuffer.notifier).getByID(data.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.updatePosition(data.screenTouchPos);
    // notifyParent(); // for circle drawing

    if (ref.read(modulation2DProv)) {
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
