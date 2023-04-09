import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class NoteEvent {
  int channel;
  final int note;
  final int velocity;

  CCMessage? ccMessage;
  NoteOnMessage? noteOnMessage;
  int releaseTime = 0;

  bool get isPlaying => noteOnMessage == null ? false : true;

  bool _kill = false;
  void markKill() => _kill = true;
  bool get kill => _kill;

  /// Create and store a NoteOn event for its lifetime as well as its release time
  NoteEvent(this.channel, this.note, this.velocity)
      : noteOnMessage = NoteOnMessage(
          channel: channel,
          note: note,
          velocity: velocity,
        );

  /// Update to keep track of when the note was last released
  void updateReleaseTime() =>
      releaseTime = DateTime.now().millisecondsSinceEpoch;

  /// Update channel for latest MPE note hit
  void updateMPEchannel(int newChan) => channel = newChan;

  /// Send this noteEvent's NoteOnMessage
  void noteOn({cc = false}) {
    noteOnMessage?.send();
    if (cc) {
      ccMessage =
          CCMessage(channel: (channel + 1) % 16, controller: note, value: 127)
            ..send();
    }
  }

  /// Cleaer Note On message without sending note off
  void clear() {
    noteOnMessage = null;
  }

  /// Send this noteEvent's NoteOffMessage, if note is still on
  void noteOff() {
    if (noteOnMessage != null) {
      NoteOffMessage(channel: channel, note: note).send();
      noteOnMessage = null;
    }
    if (ccMessage != null) {
      CCMessage(channel: (channel + 1) % 16, controller: note, value: 0).send();
      ccMessage = null;
    }
  }
}
