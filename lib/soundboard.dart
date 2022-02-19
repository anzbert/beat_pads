import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:flutter_sound_board/services/utils.dart';
import 'package:provider/provider.dart';

class Settings extends ChangeNotifier {
  bool noteNames = false;

  void showNoteNames(bool setting) {
    noteNames = setting;
    notifyListeners();
  }
}

class SoundBoard extends StatelessWidget {
  const SoundBoard({Key? key, this.lowestNote = 36, this.channel = 1})
      : super(key: key);

  final int lowestNote;
  final int channel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Settings(),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).orientation.name == "portrait"
              ? MediaQuery.of(context).size.width
              : double.infinity,
          padding: MediaQuery.of(context).orientation.name == "landscape"
              ? EdgeInsets.symmetric(horizontal: 100.0)
              : EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child:
                      ButtonRow(channel: channel, lowestNote: lowestNote + 12)),
              Expanded(
                  flex: 1,
                  child:
                      ButtonRow(channel: channel, lowestNote: lowestNote + 8)),
              Expanded(
                  flex: 1,
                  child:
                      ButtonRow(channel: channel, lowestNote: lowestNote + 4)),
              Expanded(
                  flex: 1,
                  child: ButtonRow(channel: channel, lowestNote: lowestNote)),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({Key? key, this.lowestNote = 0, this.channel = 1})
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
            child: SoundButton(paramChannel: channel, paramNote: lowestNote)),
        Expanded(
            flex: 1,
            child:
                SoundButton(paramChannel: channel, paramNote: lowestNote + 1)),
        Expanded(
            flex: 1,
            child:
                SoundButton(paramChannel: channel, paramNote: lowestNote + 2)),
        Expanded(
            flex: 1,
            child:
                SoundButton(paramChannel: channel, paramNote: lowestNote + 3)),
      ],
    );
  }
}

class SoundButton extends StatelessWidget {
  const SoundButton(
      {Key? key,
      this.paramNote = 36,
      this.paramVelocity = 127,
      this.paramChannel = 1})
      : super(key: key);

  final int paramNote;
  final int paramVelocity;
  final int paramChannel;

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
        color: Colors.green[800],
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          onTapDown: (details) {
            NoteOnMessage(
                    channel: paramChannel,
                    note: paramNote,
                    velocity: paramVelocity)
                .send();
          },
          onTapUp: (details) {
            NoteOffMessage(channel: paramChannel, note: paramNote, velocity: 0)
                .send();
          },
          splashColor: Colors.purple[900],
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Consumer<Settings>(
              builder: (context, settings, child) {
                return Text(
                    settings.noteNames
                        ? getNoteName(paramNote)
                        : paramNote.toString(),
                    style: TextStyle(color: Colors.grey[400]));
              },
            ),
          ),
        ),
      ),
    );
  }
}
