import 'package:beat_pads/components/pitch_bend.dart';
import 'package:beat_pads/state/receiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:beat_pads/temp/main_menu.dart';
import 'package:beat_pads/services/midi_utils.dart';
import 'package:provider/provider.dart';

import '../state/settings.dart';

class SoundBoard extends StatelessWidget {
  const SoundBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool inPortrait = MediaQuery.of(context).orientation.name == "portrait";

    return Scaffold(
      appBar: inPortrait
          ? AppBar(
              title: Text("Beat Pads"),
            )
          : null,
      drawer: inPortrait ? MainMenu() : null,
      body: Center(
        child: Container(
          height:
              inPortrait ? MediaQuery.of(context).size.width : double.infinity,
          padding: !inPortrait
              ? EdgeInsets.symmetric(horizontal: 50.0)
              : EdgeInsets.all(0.0),
          child: Consumer<Settings>(builder: (context, settings, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (settings.pitchBend)
                  Expanded(
                    flex: 1,
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: Consumer<MidiReceiver>(
                          builder: (context, receiver, child) => PitchBender(
                            channel: receiver.channel,
                          ),
                        )),
                  ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: ButtonRow(lowestNote: settings.baseNote + 12)),
                      Expanded(
                          flex: 1,
                          child: ButtonRow(lowestNote: settings.baseNote + 8)),
                      Expanded(
                          flex: 1,
                          child: ButtonRow(lowestNote: settings.baseNote + 4)),
                      Expanded(
                          flex: 1,
                          child: ButtonRow(lowestNote: settings.baseNote)),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({Key? key, this.lowestNote = 0, this.channel = 0})
      : super(key: key);

  final int lowestNote;
  final int channel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: SoundButton(channel: channel, paramNote: lowestNote)),
        Expanded(
            flex: 1,
            child: SoundButton(channel: channel, paramNote: lowestNote + 1)),
        Expanded(
            flex: 1,
            child: SoundButton(channel: channel, paramNote: lowestNote + 2)),
        Expanded(
            flex: 1,
            child: SoundButton(channel: channel, paramNote: lowestNote + 3)),
      ],
    );
  }
}

class SoundButton extends StatelessWidget {
  const SoundButton({
    Key? key,
    this.paramNote = 36,
    this.channel = 0,
  }) : super(key: key);

  final int paramNote;
  final int channel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      height: double.infinity,
      width: double.infinity,
      child: Consumer<MidiReceiver>(
        builder: (context, receiver, child) {
          return Material(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            elevation: 5.0,
            shadowColor: Colors.black,
            color: receiver.notes[paramNote] != 0 ? Colors.amber : Colors.green,
            child: Consumer<Settings>(builder: (context, settings, child) {
              return InkWell(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                onTapDown: (_details) {
                  NoteOnMessage(
                          channel: receiver.channel,
                          note: paramNote,
                          velocity: settings.velocity)
                      .send();
                },
                onTapUp: (_details) {
                  NoteOffMessage(
                    channel: receiver.channel,
                    note: paramNote,
                  ).send();
                },
                onTapCancel: () {
                  NoteOffMessage(
                    channel: receiver.channel,
                    note: paramNote,
                  ).send();
                },
                splashColor: Colors.purple[900],
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Text(
                      settings.noteNames
                          ? getNoteName(paramNote)
                          : paramNote.toString(),
                      style: TextStyle(color: Colors.grey[400])),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
