import 'package:beat_pads/screen_beat_pads/button_sustain.dart';
import 'package:beat_pads/screen_beat_pads/velocity_overlay.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlideBeatPad extends ConsumerStatefulWidget {
  const SlideBeatPad({required this.pad, required this.preview, super.key});

  final bool preview;
  final CustomPad pad;

  @override
  SlideBeatPadState createState() => SlideBeatPadState();
}

class SlideBeatPadState extends ConsumerState<SlideBeatPad> {
  int sustainedVelocity = 0;

  @override
  Widget build(BuildContext context) {
    final note = widget.pad.padValue;
    final bool sustainState = ref.watch(sustainStateProv);

    final int playedVelocity = ref
        .watch(senderProvider)
        .playModeHandler
        .isNoteOn(note);

    if (sustainState) {
      if (sustainedVelocity < playedVelocity) {
        sustainedVelocity = playedVelocity;
      }
    } else {
      sustainedVelocity = 0;
    }

    final Color color = ref.watch(layoutProv) == Layout.progrChange
        ? ref
              .watch(padColorsProv)
              .colorize(
                Scale.chromatic.intervals,
                ref.watch(baseHueProv),
                ref.watch(rootProv),
                note,
                0, // no Rx Midi with PROG Change
                noteOn: false, // no NoteOn with PROG Change
              )
        : ref
              .watch(padColorsProv)
              .colorize(
                ref.watch(scaleProv).intervals,
                ref.watch(baseHueProv),
                ref.watch(rootProv),
                note,
                widget.preview ? 0 : ref.watch(rxNoteProvider)[note],
                noteOn: sustainState
                    ? sustainedVelocity > 0
                    : playedVelocity > 0,
              );

    final Label label = PadLabels.getLabel(
      note: note,
      layout: ref.watch(layoutProv),
      padLabels: ref.watch(padLabelsProv),
      gmLabel: ref.watch(gmLabelsProv),
    );

    final Color padTextColor = Palette.darkGrey;
    final Color splashColor = Palette.splashColor;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double padSpacing = screenWidth * ThemeConst.padSpacingFactor;
    final BorderRadius padRadius = BorderRadius.all(
      Radius.circular(screenWidth * ThemeConst.padRadiusFactor),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        const double textHeight = 1.11;

        final double fontSize = widget.preview
            ? (constraints.maxWidth * 0.3)
                  .clamp(0, screenWidth * 0.03)
                  .clamp(
                    0,
                    constraints.maxHeight *
                        (label.subtitle == null ? 0.6 : 0.4),
                  )
                  .toDouble()
            : (constraints.maxWidth * 0.3)
                  .clamp(0, screenWidth * 0.02)
                  .clamp(
                    0,
                    constraints.maxHeight *
                        (label.subtitle == null ? 0.6 : 0.4),
                  )
                  .toDouble();

        final double subtitleFontSize = fontSize * 0.5;

        return RepaintBoundary(
          child: Container(
            decoration: ref.watch(layoutProv) == Layout.guitar
                ? (widget.pad.row + 1) % 5 == 0
                      ? BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: Palette.laserLemon,
                              width: constraints.maxHeight * 0.022,
                            ),
                          ),
                        )
                      : BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: Palette.cadetBlue,
                              width: constraints.maxHeight * 0.022,
                            ),
                          ),
                        )
                : BoxDecoration(
                    border: Border.all(
                      color: ThemeData.dark().scaffoldBackgroundColor,
                      width: padSpacing,
                    ),
                  ),
            // padding: EdgeInsets.all(padSpacing),
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Material(
                  elevation: 0,
                  color: color,
                  borderRadius: padRadius,
                  shadowColor: Colors.black,
                  child: note > 127 || note < 0
                      ? InkWell(
                          borderRadius: padRadius,
                          child: Padding(
                            padding: EdgeInsets.all(padSpacing),
                            child: Text(
                              '#',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Palette.lightGrey,
                                fontSize: fontSize * 0.8,
                                height: textHeight,
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTapDown: (_) {}, // for ink effect
                          borderRadius: padRadius,
                          highlightColor: color,
                          splashColor: splashColor,
                          child: Padding(
                            padding: EdgeInsets.all(padSpacing),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (label.subtitle != null)
                                  Flexible(
                                    child: Text(
                                      label.subtitle!,
                                      style: TextStyle(
                                        color: padTextColor,
                                        fontSize: subtitleFontSize,
                                        height: textHeight,
                                      ),
                                    ),
                                  ),
                                if (label.title != null)
                                  Flexible(
                                    child: Text(
                                      label.title!,
                                      style: TextStyle(
                                        color: padTextColor,
                                        fontSize: fontSize,
                                        height: textHeight,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                ),
                if (ref.watch(velocityVisualProv) && widget.preview == false)
                  VelocityOverlay(
                    velocity: sustainState ? sustainedVelocity : playedVelocity,
                    padRadius: padRadius,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
