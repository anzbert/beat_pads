import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class NoteEvent {
  final int channel;
  final int note;
  int releaseTime = 0;

  NoteOnMessage? noteOnMessage;

  /// Create and Send a NoteOn event, to be checked and manipulated later
  NoteEvent(this.channel, this.note, int velocity)
      : noteOnMessage = NoteOnMessage(
          channel: channel,
          note: note,
          velocity: velocity,
        );

  void updateReleaseTime() =>
      releaseTime = DateTime.now().millisecondsSinceEpoch;

  void noteOn() => noteOnMessage?.send();

  void noteOff() {
    if (noteOnMessage != null) {
      NoteOffMessage(channel: channel, note: note).send();
      noteOnMessage = null;
    }
  }
}
