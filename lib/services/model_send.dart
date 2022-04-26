import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MidiSender extends ChangeNotifier {
  MidiSender(this._settings) : _baseOctave = _settings.baseOctave;
  Settings _settings;
  int _baseOctave;

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
  final List<int> _sendBuffer = List.filled(128, 0);

  bool isNoteOn(int note) => _sendBuffer[note] != 0;

  void updateNoteInBufferAndSend(int note, bool noteOn) {
    _sendBuffer[note] = noteOn ? _settings.velocity : 0;

    if (noteOn) {
      NoteOnMessage(
        channel: _settings.channel,
        note: note,
        velocity: _settings.velocity,
      ).send();
      if (_settings.sendCC) {
        CCMessage(
          channel: (_settings.channel + 1) % 16,
          controller: note,
          value: 127,
        ).send();
      }
    } else {
      NoteOffMessage(
        channel: _settings.channel,
        note: note,
        velocity: 0,
      ).send();
      if (_settings.sendCC) {
        CCMessage(
          channel: (_settings.channel + 1) % 16,
          controller: note,
        ).send();
      }
    }
  }

  void updateSendBufferWithTouchBufferAndNotify() {
    List<int> allCurrentlyTouched = _touchBuffer.buffer
        .where((element) => element.note != null)
        .map((element) => element.note!)
        .toList();

    bool refresh = false;

    for (int n = 0; n < 128; n++) {
      if (allCurrentlyTouched.contains(n) && _sendBuffer[n] == 0) {
        updateNoteInBufferAndSend(n, true);
        refresh = true;
      } else if (!allCurrentlyTouched.contains(n) && _sendBuffer[n] != 0) {
        updateNoteInBufferAndSend(n, false);
        refresh = true;
      }
    }

    if (refresh) notifyListeners(); // notify pads for color change
  }

  // TOUCH HANDLING:
  final _touchBuffer = TouchBuffer();

  push(PointerEvent touch, int note) {
    // add event to touchbuffer and send noteOn
    _touchBuffer.buffer.add(TouchEvent(touch, note));
    updateNoteInBufferAndSend(note, true);

    notifyListeners(); // notify pads for color change
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
    // notify pads for color change
    updateSendBufferWithTouchBufferAndNotify();
  }

  lift(PointerEvent touch, int note) {
    // only send noteoff if there is a previous touch event,
    // which still has a note attached to it

    TouchEvent? eventInBuffer = _touchBuffer.findByPointer(touch.pointer);
    if (eventInBuffer?.note == null) return;

    // send noteOff and remove from touchbuffer
    updateNoteInBufferAndSend(eventInBuffer!.note!, false);
    _touchBuffer.removeEvent(touch.pointer);

    notifyListeners(); // notify pads for color change
  }

  // DISPOSE:
  @override
  dispose() {
    for (int note = 0; note < 128; note++) {
      if (_sendBuffer[note] != 0) {
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
    super.dispose();
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
      : timeStamp = touch.timeStamp,
        pointer = touch.pointer;

  final int pointer; // unique id of pointer down event
  Duration timeStamp;
  int? note;
  bool blockSlide = false;
}

// ////////////////////////////// OLD CODE:
//
//
//
// handlePush(int channel, int note, bool sendCC, int velocity, int sustainTime) {
//   if (sustainTime != 0) {
//     _triggerTime = DateTime.now().millisecondsSinceEpoch;
//   }
//   disposeChannel = channel;

//   NoteOnMessage(channel: channel, note: note, velocity: velocity).send();
//   lastNote = widget.note;

//   if (sendCC) {
//     disposeCC = true;
//     CCMessage(channel: (channel + 1) % 16, controller: note, value: 127).send();
//   } else {}
// }

// handleRelease(int channel, int note, bool? sendCC, int sustainTime) async {
//   if (sustainTime != 0) {
//     if (_checkingSustain) return;

//     _checkingSustain = true;
//     while (await _checkSustainTime(sustainTime, _triggerTime) == false) {}
//     _checkingSustain = false;
//   }
//   NoteOffMessage(
//     channel: channel,
//     note: note,
//   ).send();

//   if (sendCC == true) {
//     CCMessage(channel: (channel + 1) % 16, controller: note, value: 0).send();
//   }
// }

// Future<bool> _checkSustainTime(int sustainTime, int triggerTime) =>
//     Future.delayed(
//       const Duration(milliseconds: 5),
//       () => DateTime.now().millisecondsSinceEpoch - triggerTime > sustainTime,
//     );
