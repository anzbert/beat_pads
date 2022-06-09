import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlideBeatPad extends ConsumerWidget {
  final bool preview;

  const SlideBeatPad({
    required this.note,
    Key? key,
    required this.preview,
  }) : super(key: key);

  final int note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // PAD COLOR:
    final Color color = ref.watch(padColorsProv).colorize(
          ref.watch(scaleListProv),
          ref.watch(baseHueProv),
          ref.watch(rootProv),
          note,
          ref.watch(senderProvider).playModeHandler.isNoteOn(note),
          preview ? 0 : ref.watch(rxNoteProvider)[note],
        );

    final Color splashColor = Palette.splashColor;

    final BorderRadius padRadius = BorderRadius.all(
        Radius.circular(screenWidth * ThemeConst.padRadiusFactor));
    final double padSpacing = screenWidth * ThemeConst.padSpacingFactor;

    final Label label = PadLabels.getLabel(
        ref.watch(padLabelsProv), ref.watch(layoutProv), note);
    final double fontSize = screenWidth * 0.021;
    final Color padTextColor = Palette.darkGrey;

    return Container(
      padding: EdgeInsets.all(padSpacing),
      height: double.infinity,
      width: double.infinity,
      child: Material(
        elevation: 3,
        color: color,
        borderRadius: padRadius,
        shadowColor: Colors.black,
        child: note > 127 || note < 0
            ?
            // OUT OF MIDI RANGE
            InkWell(
                borderRadius: padRadius,
                child: Padding(
                  padding: EdgeInsets.all(padSpacing),
                  child: Text(
                    note.toString(),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Palette.lightGrey,
                      fontSize: fontSize * 0.8,
                    ),
                  ),
                ),
              )
            :
            // WITHIN MIDI RANGE
            InkWell(
                onTapDown: (_) {},
                borderRadius: padRadius,
                highlightColor: color,
                splashColor: splashColor,
                child: Padding(
                  padding: EdgeInsets.all(padSpacing),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label.subtitle != null)
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
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
                          fit: FlexFit.loose,
                          flex: 1,
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
    );
  }
}
