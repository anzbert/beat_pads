import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/services/_services.dart';

class SlideBeatPad extends StatelessWidget {
  const SlideBeatPad({
    required this.note,
    Key? key,
  }) : super(key: key);

  final int note;

  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context, listen: true);
    final double screenWidth = MediaQuery.of(context).size.width;

    final int rxNoteVelocity = note < 127 && note >= 0
        ? Provider.of<MidiReceiver>(context, listen: true).rxBuffer[note]
        : 0;
    final bool noteOn =
        Provider.of<MidiSender>(context, listen: true).isNoteOn(note);

    // PAD COLOR:
    final Color color = settings.padColors.colorize(
      settings,
      note,
      noteOn,
      rxNoteVelocity,
    );

    final Color splashColor = color.withOpacity(0.3);

    final BorderRadius padRadius = BorderRadius.all(
        Radius.circular(screenWidth * ThemeConst.padRadiusFactor));
    final double padSpacing = screenWidth * ThemeConst.padSpacingFactor;

    final Color padTextColor = Palette.darkGrey.color;
    final double fontSize = screenWidth * 0.021;

    return Container(
      padding: EdgeInsets.all(padSpacing),
      height: double.infinity,
      width: double.infinity,
      child: Material(
        color: color,
        borderRadius: padRadius,
        elevation: 5,
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
                      color: Palette.lightGrey.color,
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
                splashColor: splashColor,
                child: Padding(
                  padding: EdgeInsets.all(padSpacing),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (settings.layout.gmPercussion)
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Text(
                            MidiUtils.getNoteName(note,
                                gmPercussionLabels: true),
                            style: TextStyle(
                                color: padTextColor, fontSize: fontSize * 0.5),
                          ),
                        ),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Text(
                            settings.showNoteNames
                                ? MidiUtils.getNoteName(note)
                                : note.toString(),
                            style: TextStyle(
                                color: padTextColor, fontSize: fontSize)),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
