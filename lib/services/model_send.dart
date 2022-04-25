import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MidiSender extends ChangeNotifier {
  MidiSender(this._settings);
  final Settings _settings;
  final List<int> _sendBuffer = List.filled(128, 0);

  bool isNoteOn(int note) => _sendBuffer[note] != 0;

  updateBuffer(int index, int value) {
    _sendBuffer[index] = value;
    notifyListeners();
  }

  push(PointerEvent touch, int value) {
    updateBuffer(value, _settings.velocity);

    NoteOnMessage(
            channel: _settings.channel,
            note: value,
            velocity: _settings.velocity)
        .send();
  }

  slide(PointerEvent touch, int value) {
    // NoteOnMessage(
    //         channel: _settings.channel,
    //         note: value,
    //         velocity: _settings.velocity)
    //     .send();
  }

  lift(PointerEvent touch, int value) {
    updateBuffer(value, 0);

    NoteOffMessage(
      channel: _settings.channel,
      note: value,
    ).send();
  }

  @override
  dispose() {
    for (int n = 0; n < 128; n++) {
      if (_sendBuffer[n] != 0) {
        NoteOffMessage(
          channel: _settings.channel,
          note: n,
        ).send();
        _sendBuffer[n] = 0;
      }
    }
    super.dispose();
  }
}

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
