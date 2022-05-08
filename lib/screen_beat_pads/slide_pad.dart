import 'package:beat_pads/services/model_variables.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/services/_services.dart';

class SlideBeatPad extends StatelessWidget {
  const SlideBeatPad({
    required this.note,
    Key? key,
  }) : super(key: key);

  final int note;
  // final EdgeInsets EdgeInsets.all(padSpacing) = const EdgeInsets.all(2.5);

  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context, listen: true);

    final int rxNote = note < 127 && note >= 0
        ? Provider.of<MidiReceiver>(context, listen: true).rxBuffer[note]
        : 0;

    final bool noteOn =
        Provider.of<MidiSender>(context, listen: true).isNoteOn(note);

    // PAD COLOR:
    final Color splashColor = Palette.lightPink.color;
    final Color padTextColor = Palette.darkGrey.color;

    final Color color;
    if (noteOn) {
      color = splashColor.withAlpha(220); // maintain color when pushed

    } else if (rxNote > 0) {
      color = Palette.cadetBlue.color.withAlpha(
          rxNote * 2); // receiving midi signal adjusted by received velocity

    } else if (note > 127 || note < 0) {
      color = Palette.darkGrey.color; // out of midi range

    } else if (!MidiUtils.isNoteInScale(
        note, settings.scaleList, settings.rootNote)) {
      color = Palette.yellowGreen.color.withAlpha(160); // not in current scale

    } else if (note % 12 == settings.rootNote) {
      color = Palette.laserLemon.color; // root note

    } else {
      color = Palette.yellowGreen.color; // default pad color
    }

    double width = MediaQuery.of(context).size.width;

    double fontSize = width * 0.022;
    BorderRadius padRadius =
        BorderRadius.all(Radius.circular(width * ThemeConst.padRadiusFactor));
    double padSpacing = width * ThemeConst.padSpacingFactor;
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
