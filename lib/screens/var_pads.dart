import 'package:beat_pads/state/receiver.dart';
import 'package:beat_pads/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:provider/provider.dart';
import '../services/midi_utils.dart';

class VariablePads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int width = Provider.of<Settings>(context, listen: true).width;
    final int height = Provider.of<Settings>(context, listen: true).height;
    final int baseNote = Provider.of<Settings>(context, listen: true).baseNote;
    final int velocity = Provider.of<Settings>(context, listen: true).velocity;
    final String scale = Provider.of<Settings>(context, listen: true).scale;
    final bool showNoteNames =
        Provider.of<Settings>(context, listen: true).noteNames;
    final int channel =
        Provider.of<MidiReceiver>(context, listen: true).channel;

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
    this.scale = "minor",
  }) : super(key: key);

  final bool showNoteNames;
  final int note;
  final int channel;
  final int velocity;
  final String scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      height: double.infinity,
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        elevation: 5.0,
        shadowColor: Colors.black,
        color: Provider.of<MidiReceiver>(context, listen: true).notes[note] != 0
            ? Colors.amber[300]
            : withinScale(note, scale)
                ? Colors.green
                : Colors.green[200],
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          onTapDown: (_details) {
            NoteOnMessage(channel: channel, note: note, velocity: velocity)
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
          splashColor: Colors.purple[900],
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Text(showNoteNames ? getNoteName(note) : note.toString(),
                style: TextStyle(color: Colors.grey[400])),
          ),
        ),
      ),
    );
  }
}
