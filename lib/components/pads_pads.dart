import 'package:beat_pads/state/receiver.dart';
import 'package:beat_pads/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:provider/provider.dart';
import '../services/midi_utils.dart';

class VariablePads extends StatelessWidget {
  // TODO implement pad generator (will affect basenote)
  List<int> _generatePads(
    int baseNote,
    int width,
    int height,
    List<int> scale,
    bool scaleOnly,
  ) {
    int numPads = width * height;

    List<int> grid = List.generate(numPads, (index) {
      return scale[index % scale.length] + baseNote;
    });

    return grid;
  }

  List<List<int>> _splitToRows(List<int> grid, int width, int height) {
    return List.generate(
        height,
        (row) => List.generate(width, (note) {
              return grid[row * width + note];
            }));
  }

  List<int> _rowsVerticalMirrored(List<int> grid, int width, int height) {
    final int topLeft = width * height - width;
    var outputGrid = List.generate(grid.length, (index) {
      // final int padNote = topLeft + widthIndex - heightIndex * width;
      return grid[topLeft];
    });

    return outputGrid;
  }

  @override
  Widget build(BuildContext context) {
    final width = Provider.of<Settings>(context, listen: true).width;
    final height = Provider.of<Settings>(context, listen: true).height;

    final int baseNote = Provider.of<Settings>(context, listen: true).baseNote;
    final int velocity = Provider.of<Settings>(context, listen: true).velocity;
    final String scale = Provider.of<Settings>(context, listen: true).scale;
    final bool showNoteNames =
        Provider.of<Settings>(context, listen: true).showNoteNames;

    final int channel =
        Provider.of<MidiReceiver>(context, listen: true).channel;

    final pads = _generatePads(baseNote, width, height, midiScales[scale]!,
        Provider.of<Settings>(context, listen: true).onlyScaleNotes);

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(height, (heightIndex) {
            return Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(width, (widthIndex) {
                    final int topLeft = baseNote + width * height - width;
                    final int padNote =
                        topLeft + widthIndex - heightIndex * width;

                    return Expanded(
                      flex: 1,
                      child: BeatPad(
                        note: padNote,
                        showNoteNames: showNoteNames,
                        velocity: velocity,
                        channel: channel,
                        scale: scale,
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
    this.scale = "chromatic",
  }) : super(key: key);

  final bool showNoteNames;
  final int note;
  final int channel;
  final int velocity;
  final String scale;

  @override
  Widget build(BuildContext context) {
    int rxNote = note < 127
        ? Provider.of<MidiReceiver>(context, listen: true).rxNotes[note]
        : -1;

    final Color color;
    if (rxNote > 0) {
      color = Color.fromARGB((rxNote ~/ 127) * 255, 10, 100, 100);
    } else if (rxNote == -1) {
      color = Colors.grey;
    } else if (!withinScale(note, scale)) {
      color = Colors.green[200]!;
    } else {
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(5.0),
      height: double.infinity,
      width: double.infinity,
      child: Material(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        elevation: 5.0,
        shadowColor: Colors.black,
        child: note > 127
            ? InkWell(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                splashColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child:
                      Text("#Range", style: TextStyle(color: Colors.grey[400])),
                ),
              )
            : InkWell(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                  padding: const EdgeInsets.all(2.5),
                  child: Text(
                      showNoteNames ? getNoteName(note) : note.toString(),
                      style: TextStyle(color: Colors.grey[400])),
                ),
              ),
      ),
    );
  }
}
