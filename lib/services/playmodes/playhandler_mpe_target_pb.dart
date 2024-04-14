import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class PlayModeMPETargetPb extends PlayModeHandler {
  PlayModeMPETargetPb(super.settings, super.notifyParent)
      : mpeMods = SendMpe(
          ModPitchBendToNote(),
          settings.mpePushStyleYAxisMod.getMod(),
          ModNull(),
        ),
        channelProvider = MemberChannelProvider(
          settings.mpeMemberChannels,
          upperZone: settings.zone,
        ),
        pitchDeadzone = settings.pitchDeadzone / 100;

  final SendMpe mpeMods;
  final MemberChannelProvider channelProvider;

  /// current deadzone size in a percent fraction 0 to 1.0
  final double pitchDeadzone;

  /// The hex range of one semitone in the pitchbend 14bit range
  static const double semitonePitchbendRange = 0x3FFF / 48;

  /// coarse pitch adjustment to the tone that it is currently bent to in -1 to +1
  double pitchDistance = 0;

  /// fine adjustment of the pitch bend
  double pitchModifier = 0;

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

    /////// MPE ////////////////////
    //
    // Relative mode Slide (start with a value of 64, regardless of tap position on y-axis):
    if (settings.mpeRelativeMode) {
      mpeMods.xMod.send(newChannel, data.customPad.padValue, 0);
      mpeMods.yMod.send(newChannel, data.customPad.padValue, 0);
    }

    // Absolute mode
    else {
      // SLIDE
      mpeMods.yMod.send(
        newChannel,
        data.customPad.padValue,
        data.yPercentage * 2 - 1,
      );

      // PITCHBEND
      /// maps the 0 to 1.0 X-axis value on pad to a range between -1.0 and +1.0
      final double pitchPercentage = data.xPercentage * 2 - 1;

      if (pitchPercentage.abs() < pitchDeadzone) {
        pitchModifier = 0;
      }
      // left (negative)
      else if (pitchPercentage < 0) {
        final mappedPercentage = Utils.mapValueToTargetRange(
            pitchPercentage, -1, -pitchDeadzone, -1, 0);
        pitchModifier =
            ((semitonePitchbendRange * data.customPad.pitchBendLeft) *
                    mappedPercentage) /
                0x3FFF /
                2;
      }
      // right (positive)
      else {
        final mappedPercentage = Utils.mapValueToTargetRange(
            pitchPercentage, pitchDeadzone, 1, 0, 1);
        pitchModifier =
            ((semitonePitchbendRange * data.customPad.pitchBendRight) *
                    mappedPercentage) /
                0x3FFF /
                2;
      }

      mpeMods.xMod.send(
        newChannel,
        data.customPad.padValue,
        pitchDistance + pitchModifier,
      );
    }

    //////////////////////////////////////////////////

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

    // OVERLAY  ///////////////////////////////////
    Offset touchPosition = data.screenTouchPos;

    // ROW limit conditions
    if (settings.pitchbendOnlyOnRow &&
        data.customPad?.row != eventInBuffer.noteEvent.pad.row) {
      if (data.customPad != null) {
        if (eventInBuffer.noteEvent.pad.row < data.customPad!.row) {
          touchPosition = Offset(data.screenTouchPos.dx,
              eventInBuffer.originPadBox.padPosition.dy);
        } else if (eventInBuffer.noteEvent.pad.row > data.customPad!.row) {
          touchPosition = Offset(
              data.screenTouchPos.dx,
              eventInBuffer.originPadBox.padPosition.dy +
                  eventInBuffer.originPadBox.padSize.height);
        }
        eventInBuffer.updatePosition(touchPosition, eventInBuffer.newPadBox);
      }
    } else {
      eventInBuffer.updatePosition(touchPosition, data.padBox);
    }

    if (data.customPad != null) notifyParent(); // for overlay drawing

    if (settings.pitchbendOnlyOnRow &&
        data.customPad?.row != eventInBuffer.noteEvent.pad.row) {
      return; // send no MPE message
    }

    // MPE MESSAGE //////////////////////////////////////////////////
    if (data.customPad?.padValue != null) {
      // SLIDE
      if (data.yPercentage != null) {
        mpeMods.yMod.send(
          eventInBuffer.noteEvent.channel,
          eventInBuffer.noteEvent.note,
          data.yPercentage! * 2 - 1,
        );
      }

      // PITCHBEND
      /// coarse pitch adjustment to the tone that it is currently bent to in -1 to +1
      pitchDistance =
          ((data.customPad!.padValue - eventInBuffer.noteEvent.note) / 48)
              .clamp(-1.0, 1.0);

      if (data.xPercentage != null) {
        /// maps the 0 to 1.0 X-axis value on pad to a range between -1.0 and +1.0
        final double pitchPercentage = data.xPercentage! * 2 - 1;

        if (pitchPercentage.abs() < pitchDeadzone) {
          pitchModifier = 0;
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
  /// The MPE Push Style mode doesn't show activated notes at this stage
  /// TODO supports velocity display??
  @override
  int isNoteOn(int note) => 0;
}
