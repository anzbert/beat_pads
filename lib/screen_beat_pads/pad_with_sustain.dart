import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/screen_home/_screen_home.dart';

import 'package:beat_pads/services/midi_utils.dart';

class BeatPadSustain extends StatefulWidget {
  const BeatPadSustain({
    Key? key,
    this.note = 36,
  }) : super(key: key);

  final int note;
  @override
  State<BeatPadSustain> createState() => _BeatPadSustainState();
}

class _BeatPadSustainState extends State<BeatPadSustain> {
  int _triggerTime = DateTime.now().millisecondsSinceEpoch;
  bool _checkingSustain = false;

  handlePush(int channel, bool sendCC, int velocity, int sustainTime) {
    if (sustainTime != 0) {
      _triggerTime = DateTime.now().millisecondsSinceEpoch;
    }

    NoteOnMessage(channel: channel, note: widget.note, velocity: velocity)
        .send();
    if (sendCC) {
      CCMessage(channel: channel, controller: widget.note, value: 127).send();
    }
  }

  handleRelease(int channel, bool sendCC, int sustainTime) async {
    if (sustainTime != 0) {
      if (_checkingSustain) return;

      _checkingSustain = true;
      while (await _checkSustainTime(sustainTime, _triggerTime) == false) {}
      _checkingSustain = false;
    }

    NoteOffMessage(
      channel: channel,
      note: widget.note,
    ).send();

    if (sendCC) {
      CCMessage(channel: channel, controller: widget.note, value: 0).send();
    }
  }

  Future<bool> _checkSustainTime(int sustainTime, int triggerTime) =>
      Future.delayed(
        const Duration(milliseconds: 5),
        () => DateTime.now().millisecondsSinceEpoch - triggerTime > sustainTime,
      );

  @override
  Widget build(BuildContext context) {
    // variables from settings:
    final int rootNote = Provider.of<Settings>(context, listen: true).rootNote;
    final int sustainTime =
        Provider.of<Settings>(context, listen: true).sustainTimeExp;
    final List<int> scale =
        Provider.of<Settings>(context, listen: true).scaleList;
    final int velocity = Provider.of<Settings>(context, listen: true).velocity;
    final bool showNoteNames =
        Provider.of<Settings>(context, listen: true).showNoteNames;
    final bool sendCC = Provider.of<Settings>(context, listen: true).sendCC;

    // variables from midi receiver:
    final int channel = Provider.of<MidiData>(context, listen: true).channel;
    final int _rxNote = widget.note < 127
        ? Provider.of<MidiData>(context, listen: true).rxNoteBuffer[widget.note]
        : 0;

    // PAD COLOR:
    final Color _color;

    if (_rxNote > 0) {
      _color = Palette.cadetBlue.color; // receiving midi signal

    } else if (widget.note > 127 || widget.note < 0) {
      _color = Palette.darkGrey.color; // out of midi range

    } else if (!MidiUtils.isNoteInScale(widget.note, scale, rootNote)) {
      _color = Palette.yellowGreen.color.withAlpha(160); // not in current scale

    } else if (widget.note % 12 == rootNote) {
      _color = Palette.laserLemon.color; // root note

    } else {
      _color = Palette.yellowGreen.color; // default pad color
    }

    Color _splashColor = Palette.lightPink.color;

    Color _padTextColor = Palette.darkGrey.color;

    EdgeInsets _padPadding = const EdgeInsets.all(2.5);

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
        child: widget.note > 127 || widget.note < 0
            ?
            // OUT OF MIDI RANGE
            InkWell(
                borderRadius: _padRadius,
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                    "#${widget.note}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: _fontSize,
                    ),
                  ),
                ),
              )
            :
            // WITHIN MIDI RANGE
            InkWell(
                borderRadius: _padRadius,
                splashColor: _splashColor,
                onTapDown: (_) =>
                    handlePush(channel, sendCC, velocity, sustainTime),
                onTapUp: (_) => handleRelease(channel, sendCC, sustainTime),
                onTapCancel: () => handleRelease(channel, sendCC, sustainTime),
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                      showNoteNames
                          ? MidiUtils.getNoteName(widget.note,
                              showNoteValue: false)
                          : widget.note.toString(),
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
