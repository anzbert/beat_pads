import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

import 'package:beat_pads/state/midi.dart';
import 'package:beat_pads/state/settings.dart';

import 'package:beat_pads/services/midi_utils.dart';
import 'package:beat_pads/services/color_const.dart';

class BeatPad extends StatelessWidget {
  const BeatPad({
    Key? key,
    this.note = 36,
  }) : super(key: key);

  final int note;

  @override
  Widget build(BuildContext context) {
    // variables from settings:
    final int rootNote = Provider.of<Settings>(context, listen: true).rootNote;
    final List<int> scale =
        Provider.of<Settings>(context, listen: true).scaleList;
    final int velocity = Provider.of<Settings>(context, listen: true).velocity;
    final bool showNoteNames =
        Provider.of<Settings>(context, listen: true).showNoteNames;
    final bool sendCC = Provider.of<Settings>(context, listen: true).sendCC;

    // variables from midi receiver:
    final int channel = Provider.of<MidiData>(context, listen: true).channel;
    final int _rxNote = note < 127
        ? Provider.of<MidiData>(context, listen: true).rxNotes[note]
        : 0;

    // PAD COLOR:
    final Color _color;

    if (_rxNote > 0) {
      _color = Palette.cadetBlue.color; // receiving midi signal

    } else if (note > 127 || note < 0) {
      _color = Palette.darkGrey.color; // out of midi range

    } else if (!MidiUtils.isNoteInScale(note, scale, rootNote)) {
      _color = Palette.yellowGreen.color.withAlpha(160); // not in current scale

    } else if (note % 12 == rootNote) {
      _color = Palette.laserLemon.color; // root note

    } else {
      _color = Palette.yellowGreen.color; // default pad color
    }

    Color _splashColor = Palette.lightPink.color;

    Color _padTextColor = Palette.darkGrey.color;

    BorderRadius _padRadius = BorderRadius.all(Radius.circular(5.0));
    EdgeInsets _padPadding = const EdgeInsets.all(2.5);

    bool pressed = false;

    return Container(
      padding: const EdgeInsets.all(5.0),
      height: double.infinity,
      width: double.infinity,
      child: Material(
        color: _color,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        elevation: 5.0,
        shadowColor: Colors.black,
        child: note > 127 || note < 0
            ?
            // out of midi range:
            InkWell(
                borderRadius: _padRadius,
                child: Padding(
                  padding: _padPadding,
                  child: Text("#$note", style: TextStyle(color: _padTextColor)),
                ),
              )
            :
            // within midi range:
            InkWell(
                borderRadius: _padRadius,
                splashColor: _splashColor,
                onTapDown: (_) {
                  NoteOnMessage(
                          channel: channel, note: note, velocity: velocity)
                      .send();
                  if (sendCC) {
                    CCMessage(channel: channel, controller: note, value: 127)
                        .send();
                    pressed = true;
                    // hold to bind CC
                    Future.delayed(const Duration(milliseconds: 1500), () {
                      if (pressed) {
                        CCMessage(
                                channel: channel, controller: note, value: 126)
                            .send();
                      }
                    });
                  }
                },
                onTapUp: (_) {
                  NoteOffMessage(
                    channel: channel,
                    note: note,
                  ).send();
                  if (sendCC) {
                    CCMessage(channel: channel, controller: note, value: 0)
                        .send();
                    pressed = false;
                  }
                },
                onTapCancel: () {
                  NoteOffMessage(
                    channel: channel,
                    note: note,
                  ).send();
                  if (sendCC) {
                    CCMessage(channel: channel, controller: note, value: 0)
                        .send();
                    pressed = false;
                  }
                },
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                      showNoteNames
                          ? MidiUtils.getNoteName(note, showNoteValue: false)
                          : note.toString(),
                      style: TextStyle(color: _padTextColor)),
                ),
              ),
      ),
    );
  }
}
