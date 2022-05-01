import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

abstract class Event {
  int channel;
  int triggerTime;
  int currentNoteOn;
  bool dead = false;

  Event(this.channel, this.currentNoteOn)
      : triggerTime = DateTime.now().millisecondsSinceEpoch;

  void updateTriggerTime() =>
      triggerTime = DateTime.now().millisecondsSinceEpoch;

  kill();
}

class NoteEvent extends Event {
  NoteEvent(int channel, int note, int velocity) : super(channel, note) {
    NoteOnMessage(channel: channel, note: note, velocity: velocity).send();
  }

  revive(int newChan, int note, int velocity) {
    channel = newChan;
    NoteOnMessage(channel: newChan, note: note, velocity: velocity).send();
    dead = false;
  }

  @override
  kill() {
    NoteOffMessage(channel: channel, note: currentNoteOn).send();
    dead = true;
  }
}

// class ATEvent extends Event {}

// class SlideEvent extends Event {}

// class PitchBend extends Event {}

// class CCEvent extends Event {}
