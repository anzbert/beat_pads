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
    // GET DATA:
    final int rootNote = Provider.of<Settings>(context, listen: true).rootNote;
    final List<int> scale =
        Provider.of<Settings>(context, listen: true).scaleList;
    final bool showNoteNames =
        Provider.of<Settings>(context, listen: true).showNoteNames;

    final int _rxNote = note < 127 && note >= 0
        ? Provider.of<MidiReceiver>(context, listen: true).rxBuffer[note]
        : 0;

    final bool noteOn =
        Provider.of<MidiSender>(context, listen: true).noteIsOn(note);

    // PAD COLOR:
    final Color _color;
    final Color _splashColor = Palette.lightPink.color;
    final Color _padTextColor = Palette.darkGrey.color;

    if (noteOn) {
      _color = _splashColor.withAlpha(220); // maintain color when pushed
    } else if (_rxNote > 0) {
      _color = Palette.cadetBlue.color.withAlpha(
          _rxNote * 2); // receiving midi signal adjusted by received velocity
    } else if (note > 127 || note < 0) {
      _color = Palette.darkGrey.color; // out of midi range

    } else if (!MidiUtils.isNoteInScale(note, scale, rootNote)) {
      _color = Palette.yellowGreen.color.withAlpha(160); // not in current scale

    } else if (note % 12 == rootNote) {
      _color = Palette.laserLemon.color; // root note

    } else {
      _color = Palette.yellowGreen.color; // default pad color
    }

    Size size = MediaQuery.of(context).size;
    double _fontSize = size.width * 0.022;
    BorderRadius _padRadius =
        BorderRadius.all(Radius.circular(size.width * 0.008));

    return Container(
      padding: EdgeInsets.all(size.width * 0.005),
      height: double.infinity,
      width: double.infinity,
      child: Material(
        color: _color,
        borderRadius: _padRadius,
        elevation: 5,
        shadowColor: Colors.black,
        child: note > 127 || note < 0
            ?
            // OUT OF MIDI RANGE
            InkWell(
                onTapDown: (_) {},
                borderRadius: _padRadius,
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                    note.toString(),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: _fontSize * 0.8,
                    ),
                  ),
                ),
              )
            :
            // WITHIN MIDI RANGE
            InkWell(
                onTapDown: (_) {},
                borderRadius: _padRadius,
                splashColor: _splashColor,
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                      showNoteNames
                          ? MidiUtils.getNoteName(note, showNoteValue: false)
                          : note.toString(),
                      style: TextStyle(
                        color: _padTextColor,
                        fontSize: _fontSize,
                      )),
                ),
              ),
      ),
    );
  }
}
