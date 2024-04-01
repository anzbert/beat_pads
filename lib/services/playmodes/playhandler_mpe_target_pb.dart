import 'dart:math';

import 'package:beat_pads/services/services.dart';

class PlayModeMPETargetPb extends PlayModeHandler {
  PlayModeMPETargetPb(super.settings, super.notifyParent)
      : mpeMods = SendMpe(
          ModPitchBendToNote(),
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
      touchReleaseBuffer.removeNoteFromReleaseBuffer(data.padNote);
    }

    final int newChannel = channelProvider.provideChannel([
      ...touchBuffer.buffer,
      ...touchReleaseBuffer.buffer,
    ]); // get new channel from generator

    if (settings.modulation2D) {
      mpeMods.xMod.send(newChannel, data.padNote, 0);
      mpeMods.yMod.send(newChannel, data.padNote, 0);
    } else {
      mpeMods.rMod.send(newChannel, data.padNote, 0);
    }

    final NoteEvent noteOn = NoteEvent(
      newChannel,
      data.padNote,
      velocityProvider.velocity(data.yPercentage),
    )..noteOn();

    touchBuffer.addNoteOn(
      CustomPointer(data.pointer, data.screenTouchPos),
      noteOn,
      data.screenSize,
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

    if (data.padNote != null) {
      double pitchDistance =
          ((data.padNote! - eventInBuffer.noteEvent.note) / 48)
              .clamp(-1.0, 1.0);

      double pitchModifier = 0;
      if (data.xPercentage != null) {
        pitchModifier =
            ((0x3FFF / 48) * (data.xPercentage! * 2 - 1)) / 0x3FFF / 2;
        // Utils.logd(pitchModifier);
      }

      mpeMods.xMod.send(
        eventInBuffer.noteEvent.channel,
        eventInBuffer.noteEvent.note,
        // eventInBuffer.directionalChangeFromCenter().dx,
        pitchDistance + pitchModifier,
      );

      mpeMods.yMod.send(
        eventInBuffer.noteEvent.channel,
        eventInBuffer.noteEvent.note,
        eventInBuffer.directionalChangeFromCenter().dy,
      );
    }

    //   if (settings.modulation2D) {
    //     mpeMods.xMod.send(
    //       eventInBuffer.noteEvent.channel,
    //       eventInBuffer.noteEvent.note,
    //       eventInBuffer.directionalChangeFromCenter().dx,
    //     );
    //     mpeMods.yMod.send(
    //       eventInBuffer.noteEvent.channel,
    //       eventInBuffer.noteEvent.note,
    //       eventInBuffer.directionalChangeFromCenter().dy,
    //     );
    //   } else {
    //     mpeMods.rMod.send(
    //       eventInBuffer.noteEvent.channel,
    //       eventInBuffer.noteEvent.note,
    //       eventInBuffer.radialChange(),
    //     );
    //   }
  }
}
