import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class NoteEvent {
  int channel;

  int _releaseTime = 0;

  int get releaseTime => _releaseTime;

  int? _currentNoteOn;
  int? get currentNoteOn => _currentNoteOn;

  /// Create and Send a NoteOn event, to be checked and manipulated later
  NoteEvent(this.channel, this._currentNoteOn, int velocity) {
    NoteOnMessage(channel: channel, note: _currentNoteOn!, velocity: velocity)
        .send();
  }

  void updateReleaseTime() =>
      _releaseTime = DateTime.now().millisecondsSinceEpoch;

  void revive(int newChan, int note, int velocity) {
    channel = newChan;
    _currentNoteOn = note;
    NoteOnMessage(channel: newChan, note: note, velocity: velocity).send();
  }

  void kill() {
    if (_currentNoteOn != null) {
      updateReleaseTime();
      // TODO auto sustain function here!!!
      NoteOffMessage(channel: channel, note: currentNoteOn!).send();
      _currentNoteOn = null;
    }
  }
}
