import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class PlayModeMPETargetPb extends PlayModeHandler {
  PlayModeMPETargetPb(super.settings, super.notifyParent)
      : mpeMods = SendMod(
          ModPitchBendToNote(),
          settings.mpePushStyleYAxisMod.getMod(),
          ModNull(),
        ),
        channelProvider = MemberChannelProvider(
          settings.mpeMemberChannels,
          upperZone: settings.zone,
        ),
        pitchDeadzone = settings.mpePushPitchDeadzone / 100;

  /// Currently selected Modulations on X and Y
  final SendMod mpeMods;

  /// Creates MPE channels for each new note event
  final MemberChannelProvider channelProvider;

  /// Current x-axis deadzone size in a percent fraction 0.0 to 1.0
  final double pitchDeadzone;

  /// The value width of one semitone in the pitchbend 14bit range
  static const double semitonePitchbendRange = 0x3FFF / 48;

  /// Fraction value at which the pad registers a 1.0 (100%) of X or Y value
  /// Conversely, at {1 - [percentageEdge]} a 0.0 is recorded
  static const double percentageEdge = 0.9;

  /// Release channel in MPE channel provider when event has concluded
  @override
  void releaseMPEChannel(int channel) {
    channelProvider.releaseMPEChannel(channel);
  }

  /// Returns the velocity if a given note is ON in any channel.
  /// Checks releasebuffer and active touchbuffer
  /// The MPE Push Style mode doesn't show activated notes at this stage
  // @override
  // int isNoteOn(int note) {
  //   return 0;
  // }

  // NEW TOUCH //////////////////////////////////////////////////////////////
  /// Handles a new touch of a pad in the MPE Push style mode
  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    // Remove pressed note from buffer, if it was still on
    if (settings.modReleaseTime > 0 || settings.noteReleaseTime > 0) {
      touchReleaseBuffer.removeNoteFromReleaseBuffer(data.customPad.padValue);
    }

    /// New channel from MPE channel generator
    final int newChannel = channelProvider.provideChannel([
      ...touchBuffer.buffer,
      ...touchReleaseBuffer.buffer,
    ]);

    // ///// MPE modulation //////////////////////////////////////////////////
    //
    // RELATIVE mode (starts with a value of 64, regardless of tap position):
    if (settings.mpePushRelativeMode) {
      // 0 is the centre of -1.0 to 1.0 => 64
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
    }

    // ABSOLUTE mode (the MPE value center is always in the centre of the pad)
    else {
      // Working Variables:
      final double realYPercentage = data.yPercentage;
      final double realXPercentage = data.xPercentage;

      // Y - AXIS SLIDE ////////////////////////////////////////////////
      //
      final double clampedYPercentage = Utils.mapValueToTargetRange(
        realYPercentage.clamp(1 - percentageEdge, percentageEdge),
        1 - percentageEdge,
        percentageEdge,
        0,
        1,
      );

      mpeMods.yMod.send(
        clampedYPercentage * 2 - 1,
        newChannel,
        data.customPad.padValue,
      );

      final double leftDeadzoneBorder = 0.5 - pitchDeadzone / 2;
      final double rightDeadzoneBorder = 0.5 + pitchDeadzone / 2;

      // X - AXIS PITCHBEND ///////////////////////////////////////////
      //
      // Working variables:
      /// coarse pitch adjustment to the tone that it is currently bent to in -1 to +1
      const double pitchDistance = 0;

      /// fine adjustment of the pitch bend
      double pitchModifier = 0;

      /// maps the 0 to 1.0 X-axis value on pad to a range between -1.0 and +1.0
      final double pitchPercentage = realXPercentage * 2 - 1;

      pitchModifier = 0;
      if (realXPercentage < leftDeadzoneBorder) {
        // left (negative: -1 to [leftDeadzoneBorder])
        final mappedPercentage = Utils.mapValueToTargetRange(
          pitchPercentage.clamp(-percentageEdge, -pitchDeadzone),
          -percentageEdge,
          -pitchDeadzone,
          -1,
          0,
        );
        pitchModifier =
            ((semitonePitchbendRange * data.customPad.pitchBendLeft) *
                    mappedPercentage) /
                0x3FFF /
                2;
      }
      // right (positive: [rightDeadzoneBorder] to 1)
      else if (realXPercentage > rightDeadzoneBorder) {
        final mappedPercentage = Utils.mapValueToTargetRange(
          pitchPercentage.clamp(pitchDeadzone, percentageEdge),
          pitchDeadzone,
          percentageEdge,
          0,
          1,
        );
        pitchModifier =
            ((semitonePitchbendRange * data.customPad.pitchBendRight) *
                    mappedPercentage) /
                0x3FFF /
                2;
      }
      mpeMods.xMod.send(
        pitchDistance + pitchModifier,
        newChannel,
        data.customPad.padValue,
      );
    }

    // NOTE EVENT ///////////////////////////////////////////////
    /// [NoteEvent] to be sent via Midi, added to the [TouchEvent]
    /// and stored in the [TouchBuffer]
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

    notifyParent(); // needs to be called, since the midi_send module is still using [ChangeNotifier]
  }

  // PAN ////////////////////////////////////////////////////////////////
  //
  /// Handles finger pan movements in the MPE push style mode
  @override
  void handlePan(NullableTouchAndScreenData data) {
    final TouchEvent? eventInBuffer = touchBuffer.getByID(data.pointer) ??
        touchReleaseBuffer.getByID(data.pointer);
    if (eventInBuffer == null) return;

    // Check if finger movement has left the initial pad yet,
    // and mark the event in that case
    if (eventInBuffer.noteEvent.pad.id != data.customPad?.id &&
        data.customPad != null) {
      eventInBuffer.leftInitialPad = true;
    }

    // ROW limit conditions
    Offset touchPosition = data.screenTouchPos;

    if (settings.pitchbendOnlyOnRow &&
        data.customPad?.row != eventInBuffer.noteEvent.pad.row &&
        data.customPad != null) {
      if (eventInBuffer.noteEvent.pad.row < data.customPad!.row) {
        touchPosition = Offset(
          data.screenTouchPos.dx,
          eventInBuffer.originPadBox.padPosition.dy,
        );
      } else if (eventInBuffer.noteEvent.pad.row > data.customPad!.row) {
        touchPosition = Offset(
          data.screenTouchPos.dx,
          eventInBuffer.originPadBox.padPosition.dy +
              eventInBuffer.originPadBox.padSize.height,
        );
      }
      eventInBuffer.updatePosition(touchPosition, eventInBuffer.newPadBox);
      notifyParent();
    } else {
      eventInBuffer.updatePosition(touchPosition, data.padBox);
      notifyParent();
    }

    // Guard:
    // send no MPE message if row-limit mode is on and the touch is on a pad outside the current row
    if (settings.pitchbendOnlyOnRow &&
        data.customPad?.row != eventInBuffer.noteEvent.pad.row) {
      return;
    }

    // MPE Modulation Message ///////////////////////////////////////////
    //
    // Guards:
    if (data.customPad?.padValue == null ||
        data.yPercentage == null ||
        data.xPercentage == null) return;

    // Working Variables:
    final double realYPercentage = data.yPercentage!;
    final double realXPercentage = data.xPercentage!;

    /// coarse pitch adjustment to the tone that it is currently bent to in -1 to +1
    double pitchDistance = 0;

    /// fine adjustment of the pitch bend
    double pitchModifier = 0;

    // Y - AXIS SLIDE ///////////////////////////////////////////////////////////////////////////////
    //
    final double clampedYPercentage = Utils.mapValueToTargetRange(
      realYPercentage.clamp(1 - percentageEdge, percentageEdge),
      1 - percentageEdge,
      percentageEdge,
      0,
      1,
    );

    // RELATIVE mode
    if (settings.mpePushRelativeMode && !eventInBuffer.leftInitialPad) {
      final double yPercentageMiddle = eventInBuffer.originYPercentage;
      double sendPercentage = 0;

      if (clampedYPercentage <= yPercentageMiddle) {
        sendPercentage = Utils.mapValueToTargetRange(
          clampedYPercentage,
          0,
          yPercentageMiddle,
          0,
          0.5,
        );
      } else {
        sendPercentage = Utils.mapValueToTargetRange(
          clampedYPercentage,
          yPercentageMiddle,
          1,
          0.5,
          1,
        );
      }
      mpeMods.yMod.send(
        sendPercentage * 2 - 1,
        eventInBuffer.noteEvent.channel,
        eventInBuffer.noteEvent.note,
      );
    }
    //
    // ABSOLUTE mode
    else {
      mpeMods.yMod.send(
        clampedYPercentage * 2 - 1,
        eventInBuffer.noteEvent.channel,
        eventInBuffer.noteEvent.note,
      );
    }

    // X - AXIS PITCHBEND ///////////////////////////////////////////////////////////////////////////////
    //
    // RELATIVE mode
    if (settings.mpePushRelativeMode && eventInBuffer.leftInitialPad == false) {
      /// coarse pitch adjustment to the tone that it is currently bent to in -1 to +1
      pitchDistance = 0;

      final double clampedXPercentage = Utils.mapValueToTargetRange(
        realXPercentage.clamp(1 - percentageEdge, percentageEdge),
        1 - percentageEdge,
        percentageEdge,
        0,
        1,
      );

      final double xPercentageMiddle = eventInBuffer.originXPercentage
          .clamp(1 - percentageEdge, percentageEdge);

      /// maps the 0 to 1.0 X-axis value on pad to a range between -1.0 and +1.0
      // double pitchPercentage = realXPercentage * 2 - 1;

      pitchModifier = 0;
      double mappedPercentage = 0;

      if (clampedXPercentage <= xPercentageMiddle) {
        mappedPercentage = Utils.mapValueToTargetRange(
                  clampedXPercentage,
                  0,
                  xPercentageMiddle,
                  0,
                  0.5,
                ) *
                2 -
            1;
        pitchModifier =
            ((semitonePitchbendRange * data.customPad!.pitchBendLeft) *
                    mappedPercentage) /
                0x3FFF /
                2;
      } else {
        mappedPercentage = Utils.mapValueToTargetRange(
                  clampedXPercentage,
                  xPercentageMiddle,
                  1,
                  0.5,
                  1,
                ) *
                2 -
            1;
        pitchModifier =
            ((semitonePitchbendRange * data.customPad!.pitchBendRight) *
                    mappedPercentage) /
                0x3FFF /
                2;
      }

      mpeMods.xMod.send(
        pitchDistance + pitchModifier,
        eventInBuffer.noteEvent.channel,
        0, // Note is ignored in Pitchbend
      );
    }

    // ABSOLUTE mode
    else {
      /// coarse pitch adjustment to the tone that it is currently bent to in -1 to +1
      pitchDistance =
          ((data.customPad!.padValue - eventInBuffer.noteEvent.note) / 48)
              .clamp(-1.0, 1.0);

      final double leftDeadzoneBorder = 0.5 - pitchDeadzone / 2;
      final double rightDeadzoneBorder = 0.5 + pitchDeadzone / 2;

      // print(pitchDeadzone / 2);

      // print(["leftDZB", leftDeadzoneBorder]);
      // print(["rightDZB", rightDeadzoneBorder]);

      /// maps the 0 to 1.0 X-axis value on pad to a range between -1.0 and +1.0
      final double pitchPercentage = realXPercentage * 2 - 1;

      pitchModifier = 0;
      if (realXPercentage < leftDeadzoneBorder) {
        // left (negative: -1 to [leftDeadzoneBorder])
        final mappedPercentage = Utils.mapValueToTargetRange(
          pitchPercentage.clamp(-percentageEdge, -pitchDeadzone),
          -percentageEdge,
          -pitchDeadzone,
          -1,
          0,
        );
        pitchModifier =
            ((semitonePitchbendRange * data.customPad!.pitchBendLeft) *
                    mappedPercentage) /
                0x3FFF /
                2;

        // final finalPitchbend = pitchDistance + pitchModifier;
        // // print(["LEFT", finalPitchbend]);

        // mpeMods.xMod.send(
        //   finalPitchbend,
        //   eventInBuffer.noteEvent.channel,
        //   0, // Note is ignored in Pitchbend
        // );
      }
      // right (positive: [rightDeadzoneBorder] to 1)
      else if (realXPercentage > rightDeadzoneBorder) {
        final mappedPercentage = Utils.mapValueToTargetRange(
          pitchPercentage.clamp(pitchDeadzone, percentageEdge),
          pitchDeadzone,
          percentageEdge,
          0,
          1,
        );
        pitchModifier =
            ((semitonePitchbendRange * data.customPad!.pitchBendRight) *
                    mappedPercentage) /
                0x3FFF /
                2;

        // print(["RIGHT", finalPitchbend]);
      } else {
        // print("!In deadzone!");
      }
      final finalPitchbend = pitchDistance + pitchModifier;
      mpeMods.xMod.send(
        finalPitchbend,
        eventInBuffer.noteEvent.channel,
        0, // Note is ignored in Pitchbend
      );
    }
  }
}
