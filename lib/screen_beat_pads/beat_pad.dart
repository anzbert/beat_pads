import 'package:beat_pads/screen_beat_pads/velocity_overlay.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlideBeatPad extends ConsumerStatefulWidget {
  const SlideBeatPad({
    required this.note,
    required this.preview,
    super.key,
  });

  final bool preview;
  final int note;

  @override
  _SlideBeatPadState createState() => _SlideBeatPadState();
}

class _SlideBeatPadState extends ConsumerState<SlideBeatPad> {
  int sustainedVelocity = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int velocity = ref.watch(senderProvider).playModeHandler.isNoteOn(widget.note);
    final Color color = ref.watch(layoutProv) == Layout.progrChange
        ? ref.watch(padColorsProv).colorize(
            Scale.chromatic.intervals,
            ref.watch(baseHueProv),
            ref.watch(rootProv),
            widget.note,
            0,
            noteOn: false,
          )
        : ref.watch(padColorsProv).colorize(
            ref.watch(scaleProv).intervals,
            ref.watch(baseHueProv),
            ref.watch(rootProv),
            widget.note,
            widget.preview ? 0 : ref.watch(rxNoteProvider)[widget.note],
            noteOn: velocity != 0,
          );
    final Color splashColor = Palette.splashColor;
    final BorderRadius padRadius = BorderRadius.all(
      Radius.circular(screenWidth * ThemeConst.padRadiusFactor),
    );
    final double padSpacing = screenWidth * ThemeConst.padSpacingFactor;
    final Label label = ref.watch(layoutProv) == Layout.progrChange
        ? Label(title: '${widget.note + 1}', subtitle: 'Program')
        : PadLabels.getLabel(
            ref.watch(padLabelsProv),
            ref.watch(layoutProv),
            widget.note,
          );
    final double fontSize = screenWidth * 0.021;
    final Color padTextColor = Palette.darkGrey;

    return Container(
      padding: EdgeInsets.all(padSpacing),
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Material(
            elevation: 3,
            color: color,
            borderRadius: padRadius,
            shadowColor: Colors.black,
            child: widget.note > 127 || widget.note < 0
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
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTapDown: (_) {},
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
                                  fontSize: fontSize * 0.6,
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
              velocity: velocity,
              padRadius: padRadius,
            ),
        ],
      ),
    );
  }
}
