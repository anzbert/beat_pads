import 'package:beat_pads/services/services.dart';

class PlayModeMPE extends PlayModeHandler {
  final SendMpe mpeMods;

  PlayModeMPE(super.ref)
      : mpeMods = SendMpe(
          ref.read(mpe2DXProv).getMod(ref.read(mpePitchbendRangeProv)),
          ref.read(mpe2DYProv).getMod(ref.read(mpePitchbendRangeProv)),
          ref.read(mpe1DRadiusProv).getMod(ref.read(mpePitchbendRangeProv)),
        );

  /// Release channel in MPE channel provider
  @override
  void releaseMPEChannel(int channel) {
    ref.read(mpeChannelProv.notifier).releaseMPEChannel(channel);
  }

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    // remove note if it is still playing
    if (ref.read(modReleaseUsable) > 0 || ref.read(noteReleaseUsable) > 0) {
      ref
          .read(noteReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    int newChannel = ref.read(mpeChannelProv.notifier).provideChannel([
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
    if (ref.read(touchBuffer.notifier).eventInBuffer(data.pointer)) {
      ref.read(touchBuffer.notifier).modifyEvent(data.pointer, (eventInBuffer) {
        eventInBuffer.updatePosition(data.screenTouchPos);

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
      });
    } else if (ref
        .read(touchReleaseBuffer.notifier)
        .eventInBuffer(data.pointer)) {
      ref.read(touchReleaseBuffer.notifier).modifyEvent(data.pointer,
          (eventInBuffer) {
        eventInBuffer.updatePosition(data.screenTouchPos);

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
      });
    }
  }
}
