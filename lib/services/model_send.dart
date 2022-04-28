import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MidiSender extends ChangeNotifier {
  MidiSender(this._settings) : _baseOctave = _settings.baseOctave;
  Settings _settings;
  int _baseOctave;
  bool _disposed = false;

  MidiSender update(Settings settings) {
    _settings = settings;
    _updateBaseOctave();
    return this;
  }

  _updateBaseOctave() {
    if (_settings.baseOctave != _baseOctave) {
      // declare all events dirty
      for (TouchEvent event in _touchBuffer.buffer) {
        event.blockSlide = true;
      }
      _baseOctave = _settings.baseOctave;
    }
  }

  // SEND BUFFER:
  final List<NoteEvent> _sendBuffer =
      List.generate(128, (_) => NoteEvent(), growable: false);

  bool noteIsOn(int note) => _sendBuffer[note].noteIsOn;

  void updateSendBufferAndSend(int note, bool noteOn) async {
    if (noteOn) {
      if (_settings.sendCC) {
        CCMessage(
          channel: (_settings.channel + 1) % 16,
          controller: note,
          value: 127,
        ).send();
      }
      NoteOnMessage(
        channel: _settings.channel,
        note: note,
        velocity: _settings.velocity,
      ).send();

      _sendBuffer[note] = NoteEvent(_settings.velocity);
    } else {
      if (_settings.sendCC) {
        CCMessage(
          channel: (_settings.channel + 1) % 16,
          controller: note,
        ).send();
      }

      // SUSTAIN:
      if (_settings.sustainTimeUsable > 0) {
        if (_sendBuffer[note].checkingSustain) return;
        _sendBuffer[note].checkingSustain = true;

        while (!await Future.delayed(
          const Duration(milliseconds: 5),
          () =>
              DateTime.now().millisecondsSinceEpoch -
                  _sendBuffer[note].triggerTime >
              _settings.sustainTimeUsable,
        )) {
          // Waiting for next check in 5 milliseconds...
        }
        _sendBuffer[note].checkingSustain = false;
      }
      ////////////////

      NoteOffMessage(
        channel: _settings.channel,
        note: note,
        velocity: 0,
      ).send();

      _sendBuffer[note] = NoteEvent();
    }

    notifyListeners();
  }

  void updateSendBufferWithTouchBuffer() {
    List<int> allCurrentlyTouched = _touchBuffer.buffer
        .where((element) => element.note != null)
        .map((element) => element.note!)
        .toList();

    for (int n = 0; n < 128; n++) {
      if (allCurrentlyTouched.contains(n) && _sendBuffer[n].noteIsOff) {
        updateSendBufferAndSend(n, true);
      } else if (!allCurrentlyTouched.contains(n) && _sendBuffer[n].noteIsOn) {
        updateSendBufferAndSend(n, false);
      } else if (allCurrentlyTouched.contains(n) && _sendBuffer[n].noteIsOn) {
        _sendBuffer[n].updateTriggerTime();
      }
    }
  }

  // TOUCH HANDLING:
  final _touchBuffer = TouchBuffer();

  push(PointerEvent touch, int note) {
    // add event to touchbuffer and send noteOn
    _touchBuffer.buffer.add(TouchEvent(touch, note));
    updateSendBufferAndSend(note, true);
  }

  slide(PointerEvent touch, int? note) {
    // check if it is a legeit event that has previously been registered by a push()
    TouchEvent? eventInBuffer = _touchBuffer.findByPointer(touch.pointer);
    if (eventInBuffer == null) return;

    // check if previous events are dirty (by octave change):
    if (eventInBuffer.blockSlide) return;

    // update touchbuffer with this new event:
    _touchBuffer.updateWith(TouchEvent(touch, note));

    // update send buffer with updated touchbuffer and send noteOn and noteOff's
    updateSendBufferWithTouchBuffer();
  }

  lift(PointerEvent touch, int note) {
    // only send noteoff if there is a previous touch event,
    // which still has a note attached to it
    TouchEvent? eventInBuffer = _touchBuffer.findByPointer(touch.pointer);
    if (eventInBuffer?.note == null) return;

    // send noteOff and remove from touchbuffer
    updateSendBufferAndSend(eventInBuffer!.note!, false);
    _touchBuffer.removeEvent(touch.pointer);
  }

  // DISPOSE:
  @override
  dispose() {
    for (int note = 0; note < 128; note++) {
      if (_sendBuffer[note].noteIsOn) {
        NoteOffMessage(
          channel: _settings.channel,
          note: note,
        ).send();
        if (_settings.sendCC) {
          CCMessage(
            channel: (_settings.channel + 1) % 16,
            controller: note,
          ).send();
        }
      }
    }
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}

class TouchBuffer {
  TouchBuffer();

  List<TouchEvent> _buffer = [];
  List<TouchEvent> get buffer => _buffer;

  TouchEvent? findByPointer(int searchPointer) {
    for (TouchEvent event in _buffer) {
      if (event.pointer == searchPointer) {
        return event;
      }
    }
    return null;
  }

  bool updateWith(TouchEvent updatedEvent) {
    int index = _buffer
        .indexWhere((element) => element.pointer == updatedEvent.pointer);
    if (index == -1) return false;

    _buffer[index] = updatedEvent;
    return true;
  }

  void removeEvent(int searchID) {
    _buffer = _buffer.where((element) => element.pointer != searchID).toList();
  }
}

class TouchEvent {
  TouchEvent(PointerEvent touch, this.note)
      :
        //  timeStamp = touch.timeStamp,
        pointer = touch.pointer;

  final int pointer; // unique id of pointer down event
  // Duration timeStamp;
  int? note;
  bool blockSlide = false;
}

class NoteEvent {
  NoteEvent([this.velocity = 0])
      : triggerTime = velocity > 0 ? DateTime.now().millisecondsSinceEpoch : 0;

  final int velocity;
  int triggerTime;
  bool checkingSustain = false;

  void updateTriggerTime() =>
      triggerTime = DateTime.now().millisecondsSinceEpoch;

  bool get noteIsOn => velocity > 0 ? true : false;
  bool get noteIsOff => velocity == 0 ? true : false;
}
