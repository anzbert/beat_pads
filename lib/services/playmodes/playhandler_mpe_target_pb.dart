import 'package:beat_pads/services/services.dart';

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
      data.padBox,
    );
    notifyParent();
  }

  @override
  void handlePan(NullableTouchAndScreenData data) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer) ??
        touchReleaseBuffer.getByID(data.pointer);
    if (eventInBuffer == null) return;

    // Guard: MPE only on current row setting check
    if (settings.pitchbendOnlyOnRow &&
        data.customPad?.row != eventInBuffer.noteEvent.pad.row) return;

    // commented out, since no drawing is required as of yet
    eventInBuffer.updatePosition(data.screenTouchPos, data.padBox);
    notifyParent(); // for overlay drawing

    // print(eventInBuffer.newPosition);

    if (data.customPad?.padValue != null) {
      // SLIDE
      // if (data.yPercentage != null) {
      //   mpeMods.yMod.send(
      //     eventInBuffer.noteEvent.channel,
      //     eventInBuffer.noteEvent.note,
      //     data.yPercentage! * 2 - 1,
      //   );
      // }

      // PITCHBEND

      // TODO implement pitchbenddeadzone according to visualisation

      /// The hex range of one semitone in the pitchbend 14bit range
      const double semitonePitchbendRange = 0x3FFF / 48;

      /// coarse pitch adjustment to the tone that it is currently bent to in -1 to +1
      double pitchDistance =
          ((data.customPad!.padValue - eventInBuffer.noteEvent.note) / 48)
              .clamp(-1.0, 1.0);

      /// fine adjustment of the pitch bend
      double pitchModifier = 0;

      if (data.xPercentage != null) {
        /// current deadzone size in a percent fraction 0 to 1.0
        final double pitchDeadzone = settings.pitchDeadzone / 100;

        /// maps the 0 to 1.0 X-axis value on pad to a range between -1.0 and +1.0
        final double pitchPercentage = data.xPercentage! * 2 - 1;

        // print(pitchPercentage);

        if (pitchPercentage.abs() < pitchDeadzone) {
          pitchModifier = 0;
          // print("deadzone: $pitchPercentage");
        }
        // left (negative)
        else if (pitchPercentage < 0) {
          final mappedPercentage = Utils.mapValueToTargetRange(
              pitchPercentage, -1, -pitchDeadzone, -1, 0);
          pitchModifier =
              ((semitonePitchbendRange * data.customPad!.pitchBendLeft) *
                      mappedPercentage) /
                  0x3FFF /
                  2;
        }
        // right (positive)
        else {
          final mappedPercentage = Utils.mapValueToTargetRange(
              pitchPercentage, pitchDeadzone, 1, 0, 1);
          pitchModifier =
              ((semitonePitchbendRange * data.customPad!.pitchBendRight) *
                      mappedPercentage) /
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

  /// Returns the velocity if a given note is ON in any channel.
  /// Checks releasebuffer and active touchbuffer
  /// Don't show onPads in this mode yet. TODO show all same notes as on
  @override
  int isNoteOn(int note) => 0;
}
