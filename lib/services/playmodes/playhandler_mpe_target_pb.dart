import 'package:beat_pads/services/services.dart';

// TODO Add seamless slides for non-chromatic modes

class PlayModeMPETargetPb extends PlayModeHandler {
  PlayModeMPETargetPb(super.settings, super.notifyParent)
      : mpeMods = SendMpe(
          ModPitchBendToNote(),
          ModCC642D(CC.slide),
          ModNull(),
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

    /// new channel from MPE channel generator
    final int newChannel = channelProvider.provideChannel([
      ...touchBuffer.buffer,
      ...touchReleaseBuffer.buffer,
    ]);

    mpeMods.xMod.send(newChannel, data.customPad.padValue, 0);

    // Relative mode Slide (start with a value of 64, regardless of tap position on y-axis):
    // mpeMods.yMod.send(newChannel, data.padNote, 0);

    // Absolute mode Slide (send slide value according to y-position of tap):
    mpeMods.yMod.send(
      newChannel,
      data.customPad.padValue,
      data.yPercentage * 2 - 1,
    );

    final NoteEvent noteOn = NoteEvent(
      newChannel,
      data.customPad,
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
  void handlePan(NullableTouchAndScreenData data) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer) ??
        touchReleaseBuffer.getByID(data.pointer);
    if (eventInBuffer == null) return;

    // commented out, since no drawing is required as of yet
    // eventInBuffer.updatePosition(data.screenTouchPos);
    // notifyParent(); // for overlay drawing

    if (data.customPad?.padValue != null) {
      // Guard: MPE only on current row
      if (settings.pitchbendOnlyOnRow &&
          data.customPad?.row != eventInBuffer.noteEvent.pad.row) return;

      // SLIDE
      if (data.yPercentage != null) {
        mpeMods.yMod.send(
          eventInBuffer.noteEvent.channel,
          eventInBuffer.noteEvent.note,
          data.yPercentage! * 2 - 1,
        );
      }

      // PITCHBEND
      const double semitonePitchbendRange = 0x3FFF / 48;

      double pitchDistance =
          ((data.customPad!.padValue - eventInBuffer.noteEvent.note) / 48)
              .clamp(-1.0, 1.0);

      double pitchModifier = 0;
      if (data.xPercentage != null) {
        // slide left
        if (data.xPercentage! < 0.5) {
          pitchModifier = (semitonePitchbendRange *
                  data.customPad!.pitchBendLeft *
                  (data.xPercentage! * 2 - 1)) /
              0x3FFF /
              2;
        }
        // slide right
        else {
          pitchModifier = (semitonePitchbendRange *
                  data.customPad!.pitchBendRight *
                  (data.xPercentage! * 2 - 1)) /
              0x3FFF /
              2;
        }
      }

      mpeMods.xMod.send(
        eventInBuffer.noteEvent.channel,
        eventInBuffer.noteEvent.note,
        pitchDistance + pitchModifier,
      );
    }
  }
}
