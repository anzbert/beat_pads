import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MidiSender extends ChangeNotifier {
  MidiSender(this._settings);
  final Settings _settings;

  // SEND BUFFER:
  final List<int> _sendBuffer = List.filled(128, 0);

  bool isNoteOn(int note) => _sendBuffer[note] != 0;

  void noteToBufferAndSend(int note, bool noteOn) {
    _sendBuffer[note] = noteOn ? _settings.velocity : 0;
    if (noteOn) {
      NoteOnMessage(
        channel: _settings.channel,
        note: note,
        velocity: _settings.velocity,
      ).send();
    } else {
      NoteOffMessage(
        channel: _settings.channel,
        note: note,
        velocity: 0,
      ).send();
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
        noteToBufferAndSend(n, true);
        refresh = true;
      } else if (!allCurrentlyTouched.contains(n) && _sendBuffer[n] != 0) {
        noteToBufferAndSend(n, false);
        refresh = true;
      }
    }

    if (refresh) notifyListeners();
  }

  // TOUCH HANDLING:
  final _touchBuffer = TouchBuffer();

  push(PointerEvent touch, int note) {
    _touchBuffer.buffer.add(TouchEvent(touch, note));
    noteToBufferAndSend(note, true);
    notifyListeners();
  }

  slide(PointerEvent touch, int? note) {
    TouchEvent? eventInBuffer = _touchBuffer.findByPointer(touch.pointer);
    if (eventInBuffer == null) return;

    _touchBuffer.updateWith(TouchEvent(touch, note));

    updateSendBufferWithTouchBufferAndNotify();
  }

  lift(PointerEvent touch, int note) {
    noteToBufferAndSend(note, false);
    notifyListeners();
    _touchBuffer.removeEvent(touch.pointer);
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
