import 'package:beat_pads/services/gen_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

import 'package:beat_pads/state/midi.dart';
import 'package:beat_pads/state/settings.dart';

import 'package:beat_pads/services/midi_utils.dart';
import 'package:beat_pads/services/color_const.dart';

import 'package:beat_pads/components/paint_line.dart';

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
  double startX = 0;
  double startY = 0;
  double x = 0;
  double y = 0;
  int atValue = 0;

  Offset o1 = const Offset(0, 0);
  Offset o2 = const Offset(0, 0);
  bool showLine = false;

  int distToVelocity(double x, double y, double scale) {
    int dist = (Utils.distance(0, 0, x, y) * scale).toInt();
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

    // bool pressed = false;

    return Container(
      padding: const EdgeInsets.all(5.0),
      height: double.infinity,
      width: double.infinity,
      child: Material(
          color: _color,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          elevation: 5.0,
          shadowColor: Colors.black,
          child: GestureDetector(
            onPanStart: (pan) {
              startX = pan.globalPosition.dx;
              startY = pan.globalPosition.dy;
              print("panStart: x: $x / y: $y");

              o1 = pan.globalPosition;
              o2 = pan.globalPosition;

//                         print(o1);
              showLine = true;
            },
            onPanEnd: (_) {
              print(
                  "panEnd: x: $x / y: $y / dist: ${Utils.distance(0, 0, x, y)}");
              x = 0;
              y = 0;

              setState(() => showLine = false);
            },
            onPanUpdate: (pan) {
              x = pan.globalPosition.dx - startX;
              y = pan.globalPosition.dy - startY;
              int converted = distToVelocity(x, y, 1.0);

              o2 = pan.globalPosition;

              setState(() {
                if (converted != velocity) {
                  atValue = converted;
                }
              });
            },
            onPanCancel: () {
              print(
                  "panCancel: x: $x / y: $y / dist: ${Utils.distance(0, 0, x, y)}");
              x = 0;
              y = 0;
            },
            child: widget.note > 127 || widget.note < 0
                ?
                // out of midi range:
                InkWell(
                    borderRadius: _padRadius,
                    child: Padding(
                      padding: _padPadding,
                      child: Text("#${widget.note}",
                          style: TextStyle(color: _padTextColor)),
                    ),
                  )
                :
                // within midi range:
                InkWell(
                    borderRadius: _padRadius,
                    splashColor: _splashColor,
                    onTapDown: (_) {
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
                        // pressed = true;
                        // // hold to bind CC
                        // Future.delayed(const Duration(milliseconds: 1500), () {
                        //   if (pressed) {
                        //     CCMessage(
                        //             channel: channel, controller: note, value: 126)
                        //         .send();
                        //   }
                        // });
                      }
                    },
                    onTapUp: (_) {
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
                        // pressed = false;
                      }
                    },
                    onTapCancel: () {
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
                        // pressed = false;
                      }
                    },
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
          )),
    );
  }
}
