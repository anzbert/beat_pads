import 'package:beat_pads/services/services.dart';

class PlayModeMPE extends PlayModeHandler {
  PlayModeMPE(super.refRead, SendMpe mpeMods, MPEChannelGenerator mpeChannelGen)
      : _mpeMods = mpeMods,
        _mpeChannelGenerator = mpeChannelGen;

  final SendMpe _mpeMods;
  final MPEChannelGenerator _mpeChannelGenerator;

  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    // remove note if it is still playing
    if (refRead(modReleaseUsable) > 0 || refRead(noteReleaseUsable) > 0) {
      refRead(noteReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    final newChannel = _mpeChannelGenerator.provideChannel([
      ...refRead(touchBuffer),
      ...refRead(touchReleaseBuffer)
    ]); // get new channel from generator

    if (refRead(modulation2DProv)) {
      _mpeMods.xMod.send(newChannel, data.padNote, 0);
      _mpeMods.yMod.send(newChannel, data.padNote, 0);
    } else {
      _mpeMods.rMod.send(newChannel, data.padNote, 0);
    }

    final noteOn = NoteEvent(
      newChannel,
      data.padNote,
      refRead(velocitySliderValueProv.notifier)
          .generateVelocity(data.yPercentage),
    )..noteOn();

    refRead(touchBuffer.notifier).addNoteOn(
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

    if (refRead(
      touchBuffer.notifier,
    ).modifyEventWithPointerId(data.pointer, modify)) {
    } else if (refRead(
      touchReleaseBuffer.notifier,
    ).modifyEventWithPointerId(data.pointer, modify)) {
    } else {
      return;
    }

    if (refRead(modulation2DProv) && event != null) {
      _mpeMods.xMod.send(
        event!.noteEvent.channel,
        event!.noteEvent.note,
        event!.directionalChangeFromCenter().dx,
      );
      _mpeMods.yMod.send(
        event!.noteEvent.channel,
        event!.noteEvent.note,
        event!.directionalChangeFromCenter().dy,
      );
    } else {
      _mpeMods.rMod.send(
        event!.noteEvent.channel,
        event!.noteEvent.note,
        event!.radialChange(),
      );
    }
  }

  @override
  void handleEndTouch(CustomPointer touch) {
    if (!refRead(touchBuffer.notifier).eventInBuffer(touch.pointer)) return;

    if (refRead(modReleaseUsable) == 0 && refRead(noteReleaseUsable) == 0) {
      refRead(touchBuffer.notifier).modifyEventWithPointerId(touch.pointer,
          (event) {
        releaseMPEChannel(event.noteEvent.channel);
      });
    }
    super.handleEndTouch(touch);
  }

  /// Used in MPE Mode to make a memberchannel available again for new
  /// touch events
  void releaseMPEChannel(int channel) {
    _mpeChannelGenerator.releaseMPEChannel(channel);
  }
}
