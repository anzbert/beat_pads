import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class NoteEvent {
  int channel;
  int releaseTime = 0;
  int? currentNoteOn;

  bool checkingSustain = false;

  /// Create and Send a NoteOn event, to be checked and manipulated later
  NoteEvent(this.channel, this.currentNoteOn, int velocity) {
    NoteOnMessage(channel: channel, note: currentNoteOn!, velocity: velocity)
        .send();
  }

  // void revive(int newChan, int note, int velocity) {
  //   channel = newChan;
  //   _currentNoteOn = note;
  //   NoteOnMessage(channel: newChan, note: note, velocity: velocity).send();
  // }

  void updateReleaseTime() =>
      releaseTime = DateTime.now().millisecondsSinceEpoch;

  void noteOff() {
    if (currentNoteOn != null) {
      NoteOffMessage(channel: channel, note: currentNoteOn!).send();
      currentNoteOn = null;
    }
  }
}
