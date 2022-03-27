import 'package:beat_pads/services/gen_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

import 'package:beat_pads/state/midi.dart';
import 'package:beat_pads/state/settings.dart';

import 'package:beat_pads/services/midi_utils.dart';
import 'package:beat_pads/services/color_const.dart';

// import 'package:beat_pads/components/paint_line.dart';

class BeatPad extends StatefulWidget {
  const BeatPad({
    Key? key,
    this.note = 36,
  }) : super(key: key);

  final int note;

  @override
  State<BeatPad> createState() => _BeatPadState();
}

class _BeatPadState extends State<BeatPad> {
  final GlobalKey _key = GlobalKey();

  static const int _minTriggerTime = 8; // in milliseconds

  bool playing = false;
  int lastPressure = 0;

  Offset o1 = const Offset(0, 0);
  Offset o2 = const Offset(0, 0);
  bool showLine = false;

  int distanceToMidi(Offset o1, Offset o2, double scale) {
    int dist = (Utils.offsetDistance(o1, o2) * scale).toInt();
    return dist.clamp(0, 127);
  }

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
    final int _rxNote = widget.note < 127 && widget.note > 0
        ? Provider.of<MidiData>(context, listen: true).rxNotes[widget.note]
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

    BorderRadius _padRadius = BorderRadius.all(Radius.circular(5.0));
    EdgeInsets _padPadding = const EdgeInsets.all(2.5);

    return Container(
      padding: const EdgeInsets.all(5.0),
      height: double.infinity,
      width: double.infinity,
      child: Material(
        key: _key,
        color: _color,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        elevation: 5.0,
        shadowColor: Colors.black,
        child: widget.note > 127 || widget.note < 0
            ?

            // OUT OF MIDI RANGE
            InkWell(
                borderRadius: _padRadius,
                child: Padding(
                  padding: _padPadding,
                  child: Text("#${widget.note}",
                      style: TextStyle(color: _padTextColor)),
                ),
              )
            :

            // WITHIN MIDI RANGE
            GestureDetector(
                onTapDown: (_) {
                  // print("tapDown - noteOn");
                  if (!playing) {
                    NoteOnMessage(
                            channel: channel,
                            note: widget.note,
                            velocity: velocity)
                        .send();
                    if (sendCC) {
                      CCMessage(
                              channel: channel,
                              controller: widget.note,
                              value: 127)
                          .send();
                    }
                    playing = true;
                  }
                },

                onPanStart: (_) {
                  // print("panStart - noteOn");
                  if (!playing) {
                    NoteOnMessage(
                            channel: channel,
                            note: widget.note,
                            velocity: velocity)
                        .send();
                    if (sendCC) {
                      CCMessage(
                              channel: channel,
                              controller: widget.note,
                              value: 127)
                          .send();
                    }
                    playing = true;
                  }
                },

                onPanUpdate: (pan) {
                  o1 = Utils.getCenterOffset(_key)!;
                  o2 = pan.globalPosition;
                  int convertedToPressure = distanceToMidi(o1, o2, 0.5);
                  if (lastPressure != convertedToPressure) {
                    PolyATMessage(
                            channel: channel,
                            note: widget.note,
                            pressure: convertedToPressure)
                        .send();
                    lastPressure = convertedToPressure;
                  }
                },

                onPanEnd: (_) {
                  // print("panEnd - noteOff");
                  Future.delayed(Duration(milliseconds: _minTriggerTime), () {
                    NoteOffMessage(
                      channel: channel,
                      note: widget.note,
                    ).send();

                    PolyATMessage(
                            channel: channel, note: widget.note, pressure: 0)
                        .send();

                    if (sendCC) {
                      CCMessage(
                              channel: channel,
                              controller: widget.note,
                              value: 0)
                          .send();
                    }
                    playing = false;
                  });
                },

                onTapUp: (_) {
                  // print("tapUp - NoteOff");
                  Future.delayed(Duration(milliseconds: _minTriggerTime), () {
                    NoteOffMessage(
                      channel: channel,
                      note: widget.note,
                    ).send();

                    if (sendCC) {
                      CCMessage(
                              channel: channel,
                              controller: widget.note,
                              value: 0)
                          .send();
                    }
                    playing = false;
                  });
                },

                // onPanCancel: () => print("panCancel (no action)"),
                // onTapCancel: () => print("tapCancel - no action"),

                child: InkWell(
                  borderRadius: _padRadius,
                  splashColor: _splashColor,
                  child: Padding(
                    padding: _padPadding,
                    child: Text(
                        showNoteNames
                            ? MidiUtils.getNoteName(widget.note,
                                showNoteValue: false)
                            : widget.note.toString(),
                        style: TextStyle(color: _padTextColor)),
                  ),
                ),
              ),
      ),
    );
  }
}
