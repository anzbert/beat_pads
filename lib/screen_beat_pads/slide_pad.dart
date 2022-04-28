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
  final EdgeInsets _padPadding = const EdgeInsets.all(2.5);

  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context, listen: true);

    final int rxNote = note < 127 && note >= 0
        ? Provider.of<MidiReceiver>(context, listen: true).rxBuffer[note]
        : 0;

    final bool noteOn =
        Provider.of<MidiSender>(context, listen: true).noteIsOn(note);

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

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.022;
    BorderRadius padRadius =
        BorderRadius.all(Radius.circular(screenWidth * 0.008));

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.005),
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
                onTapDown: (_) {},
                borderRadius: padRadius,
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                    note.toString(),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
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
                  padding: _padPadding,
                  child: Text(
                      settings.layout == Layout.XpressPads_Standard ||
                              settings.layout == Layout.XpressPads_LatinJazz ||
                              settings.layout == Layout.XpressPads_Xtreme
                          ? "${MidiUtils.getNoteName(note, gmPercussionLabels: true)} (${settings.showNoteNames ? MidiUtils.getNoteName(note) : note.toString()})"
                          : settings.showNoteNames
                              ? MidiUtils.getNoteName(note)
                              : note.toString(),
                      style: TextStyle(
                        color: padTextColor,
                        fontSize: fontSize,
                      )),
                ),
              ),
      ),
    );
  }
}