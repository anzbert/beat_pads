import 'package:beat_pads/services/_services.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

abstract class Event {
  final int channel;
  int triggerTime;
  int note;

  Event(this.channel, this.note)
      : triggerTime = DateTime.now().millisecondsSinceEpoch;

  void updateTriggerTime() =>
      triggerTime = DateTime.now().millisecondsSinceEpoch;

  kill();
}

class NoteEvent extends Event {
  NoteEvent(int channel, int note, int velocity) : super(channel, note) {
    NoteOnMessage(channel: channel, note: note, velocity: velocity).send();
  }

  @override
  kill() {
    NoteOffMessage(channel: channel, note: note).send();
  }
}


class ATEvent extends Event{

}

class SlideEvent 