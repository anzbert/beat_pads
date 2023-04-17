import 'package:beat_pads/services/services.dart';

class PlayModeMPE extends PlayModeHandler {
  PlayModeMPE(super.ref)
      : mpeMods = SendMpe(
          ref.read(mpe2DXProv).getMod(ref.read(mpePitchbendRangeProv)),
          ref.read(mpe2DYProv).getMod(ref.read(mpePitchbendRangeProv)),
          ref.read(mpe1DRadiusProv).getMod(ref.read(mpePitchbendRangeProv)),
        ),
        mpeChannelGenerator = MPEChannelGenerator(
          memberChannels: ref.read(mpeMemberChannelsProv),
          upperZone: ref.read(zoneProv),
        );

  final SendMpe mpeMods;
  final MPEChannelGenerator mpeChannelGenerator;

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    // remove note if it is still playing
    if (ref.read(modReleaseUsable) > 0 || ref.read(noteReleaseUsable) > 0) {
      ref
          .read(noteReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    final newChannel = mpeChannelGenerator.provideChannel([
      ...ref.read(touchBuffer),
      ...ref.read(touchReleaseBuffer)
    ]); // get new channel from generator

    if (ref.read(modulation2DProv)) {
      mpeMods.xMod.send(newChannel, data.padNote, 0);
      mpeMods.yMod.send(newChannel, data.padNote, 0);
    } else {
      mpeMods.rMod.send(newChannel, data.padNote, 0);
    }

    final noteOn = NoteEvent(
      newChannel,
      data.padNote,
      ref.read(velocitySliderValueProv.notifier).velocity(data.yPercentage),
    )..noteOn();

    ref.read(touchBuffer.notifier).addNoteOn(
          CustomPointer(data.pointer, data.screenTouchPos),
          noteOn,
          data.screenSize,
        );
  }

  @override
  // void handlePan(CustomPointer touch, int? note) {
  void handlePan(NullableTouchAndScreenData data) {
    TouchEvent? event;

    void modify(TouchEvent eventInBuffer) {
      eventInBuffer.updatePosition(data.screenTouchPos);
      event = eventInBuffer;
    }

    if (ref
        .read(
          touchBuffer.notifier,
        )
        .modifyEvent(data.pointer, modify)) {
    } else if (ref
        .read(
          touchReleaseBuffer.notifier,
        )
        .modifyEvent(data.pointer, modify)) {
    } else {
      return;
    }

    if (ref.read(modulation2DProv) && event != null) {
      mpeMods.xMod.send(
        event!.noteEvent.channel,
        event!.noteEvent.note,
        event!.directionalChangeFromCenter().dx,
      );
      mpeMods.yMod.send(
        event!.noteEvent.channel,
        event!.noteEvent.note,
        event!.directionalChangeFromCenter().dy,
      );
    } else {
      mpeMods.rMod.send(
        event!.noteEvent.channel,
        event!.noteEvent.note,
        event!.radialChange(),
      );
    }
  }

  @override
  void handleEndTouch(CustomPointer touch) {
    if (!ref.read(touchBuffer.notifier).eventInBuffer(touch.pointer)) return;

    if (ref.read(modReleaseUsable) == 0 && ref.read(noteReleaseUsable) == 0) {
      ref.read(touchBuffer.notifier).modifyEvent(touch.pointer, (event) {
        releaseMPEChannel(event.noteEvent.channel);
      });
    }
    super.handleEndTouch(touch);
  }

  /// Used in MPE Mode to make a memberchannel available again for new
  /// touch events
  void releaseMPEChannel(int channel) {
    mpeChannelGenerator.releaseMPEChannel(channel);
  }
}
