import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class NoteEvent {
  final int channel;
  final int note;

  NoteOnMessage? noteOnMessage;
  int releaseTime = 0;

  /// Create and store a NoteOn event for its lifetime as well as its release time
  NoteEvent(this.channel, this.note, int velocity)
      : noteOnMessage = NoteOnMessage(
          channel: channel,
          note: note,
          velocity: velocity,
        );

  /// Update to keep track of when the note was last released
  void updateReleaseTime() =>
      releaseTime = DateTime.now().millisecondsSinceEpoch;

  /// Send this noteEvent's NoteOnMessage
  void noteOn() => noteOnMessage?.send();

  /// Send this noteEvent's NoteOffMessage, if note is still on
  void noteOff() {
    if (noteOnMessage != null) {
      NoteOffMessage(channel: channel, note: note).send();
      noteOnMessage = null;
    }
  }
}

class ModMapping {
  PolyATMessage? polyAT;
  CCMessage? cc;
  CCMessage? cc2;
  ATMessage? at;
  PitchBendMessage? pitchBend;

  /// All Modulation Midi Messages possible on a pad
  ModMapping({this.polyAT, this.cc, this.at, this.pitchBend});
}
