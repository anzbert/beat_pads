import 'package:flutter/material.dart';

import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/state/receiver.dart';
import 'package:beat_pads/state/settings.dart';

import 'package:beat_pads/components/drop_down_layout.dart';
import '../services/midi_utils.dart';

class VariablePads extends StatelessWidget {
  List<int> _generateNotes(
    int rootNote,
    int baseNote,
    int width,
    int height,
    List<int> scale,
    bool scaleOnly,
    Layout layout,
  ) {
    List<int> grid = [];
    if (scaleOnly == true && layout == Layout.continuous) {
      grid = scaleOnlyGrid(rootNote, scale, baseNote, width * height);
    } else if (scaleOnly == false) {
      grid = createGrid(layout, baseNote, width, height);
    }

    if (grid.length != width * height) throw Exception("PAds: wrong grid size");
    return grid;
  }

  List<List<int>> _splitToReversedRows(List<int> grid, int width, int height) {
    return List.generate(
        height,
        (row) => List.generate(width, (note) {
              return grid[row * width + note];
            })).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = Provider.of<Settings>(context, listen: true).width;
    final height = Provider.of<Settings>(context, listen: true).height;

    final int baseNote = Provider.of<Settings>(context, listen: true).baseNote;
    final int rootNote = Provider.of<Settings>(context, listen: true).rootNote;
    final int velocity = Provider.of<Settings>(context, listen: true).velocity;
    final String scaleName = Provider.of<Settings>(context, listen: true).scale;
    final List<int> scale = midiScales[scaleName]!;

    final bool showNoteNames =
        Provider.of<Settings>(context, listen: true).showNoteNames;

    final int channel =
        Provider.of<MidiReceiver>(context, listen: true).channel;

    final pads = _generateNotes(
      rootNote,
      baseNote,
      width,
      height,
      scale,
      Provider.of<Settings>(context, listen: true).onlyScaleNotes,
      Provider.of<Settings>(context, listen: true).layout,
    );

    final padRows = _splitToReversedRows(pads, width, height);

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: padRows.map((row) {
            return Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: row.map((padNote) {
                    return Expanded(
                      flex: 1,
                      child: BeatPad(
                        note: padNote,
                        showNoteNames: showNoteNames,
                        velocity: velocity,
                        channel: channel,
                        scale: scale,
                        scaleRootNote: rootNote,
                      ),
                    );
                  }).toList()),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BeatPad extends StatelessWidget {
  const BeatPad({
    Key? key,
    this.note = 36,
    this.channel = 0,
    this.velocity = 127,
    this.showNoteNames = false,
    this.scale = const [],
    this.scaleRootNote = 0,
  }) : super(key: key);

  final bool showNoteNames;
  final int note;
  final int channel;
  final int velocity;
  final List<int> scale;
  final int scaleRootNote;

  @override
  Widget build(BuildContext context) {
    int _rxNote = note < 127
        ? Provider.of<MidiReceiver>(context, listen: true).rxNotes[note]
        : 0;

    final Color _color;
    if (_rxNote > 0) {
      _color = Color.fromARGB(
          (_rxNote ~/ 127) * 255, 10, 100, 100); // receiving midi
    } else if (note > 127 || note < 0) {
      _color = Colors.grey; // out of range
    } else if (!isNoteInScale(note, scale, scaleRootNote)) {
      _color = Color.fromARGB(255, 77, 109, 78); // outside of current scale
    } else if (note % 12 == scaleRootNote) {
      _color = Colors.teal[400]!;
    } else {
      _color = Colors.green; // default color
    }

    var _padRadius = BorderRadius.all(Radius.circular(5.0));
    var _padPadding = const EdgeInsets.all(2.5);
    var _padTextColor = Colors.grey[400];

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
            ? InkWell(
                borderRadius: _padRadius,
                child: Padding(
                  padding: _padPadding,
                  child: Text("#$note", style: TextStyle(color: _padTextColor)),
                ),
              )
            : InkWell(
                borderRadius: _padRadius,
                splashColor: Colors.purple[900],
                onTapDown: (_details) {
                  NoteOnMessage(
                          channel: channel, note: note, velocity: velocity)
                      .send();
                },
                onTapUp: (_details) {
                  NoteOffMessage(
                    channel: channel,
                    note: note,
                  ).send();
                },
                onTapCancel: () {
                  NoteOffMessage(
                    channel: channel,
                    note: note,
                  ).send();
                },
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                      showNoteNames
                          ? getNoteName(note, showNoteValue: false)
                          : note.toString(),
                      style: TextStyle(color: _padTextColor)),
                ),
              ),
      ),
    );
  }
}
