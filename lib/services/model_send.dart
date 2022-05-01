import 'dart:math';

import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MidiSender extends ChangeNotifier {
  MidiSender(this._settings)
      : _baseOctave = _settings.baseOctave,
        _touchBuffer = TouchBuffer(_settings.maxMPEControlDrawRadius) {
    if (_settings.playMode == PlayMode.mpe) {
      MPEinitMessage(
          memberChannels: _settings.memberChannels,
          upperZone: _settings.upperZone);
    }
  }

  Settings _settings;
  int _baseOctave;
  bool _disposed = false;
  final TouchBuffer _touchBuffer;

  MidiSender update(Settings settings) {
    _settings = settings;
    // Handle all setting changes happening in the lifetime of the pad grid here.
    // At the moment only octave changes affect it.
    _updateBaseOctave();
    return this;
  }

  _updateBaseOctave() {
    if (_settings.baseOctave != _baseOctave) {
      for (TouchEvent event in _touchBuffer.buffer) {
        event.markDirty();
      }
      _baseOctave = _settings.baseOctave;
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//  MIDI HANDLING:
  final List<List<bool>> _noteOnMemory =
      List.filled(16, List.filled(128, false));

  bool isNoteOnInAnyChannel(int note) {
    if (_settings.playMode != PlayMode.mpe) {
      return _noteOnMemory[_settings.channel][note];
    }
    // TODO maybe refine check, depending on MPE range
    for (List<bool> channel in _noteOnMemory) {
      if (channel[note] == true) {
        return true;
      }
    }
    return false;
  }

  final Random random = Random(); // temporary
  int getChannel() {
    if (_settings.playMode != PlayMode.mpe) {
      return _settings.channel;
    } else {
      return _settings.upperZone
          ? random.nextInt(_settings.memberChannels)
          : random.nextInt(_settings.memberChannels) + 1;
      // TODO: implement channel provider / temporary lower zone with 15 members
    }
  }

  void updateMidi(TouchBuffer touches) {
    for (TouchEvent touch in touches.buffer) {
      if (touch.isNew) {
        _noteOnMemory[touch.noteEvent.channel][touch.noteEvent.note] = true;
        notifyListeners();
      }
    }

    for (TouchEvent touch in touches.buffer) {
      if (touch.didMove) {
        if (touch.hoveringNote != touch.noteEvent.note) {
          touch.noteEvent.kill();
          _noteOnMemory[touch.noteEvent.channel][touch.noteEvent.note] = false;
          notifyListeners();

          if (touch.hoveringNote != null) {
            touch.noteEvent = NoteEvent(
                getChannel(), touch.hoveringNote!, _settings.velocity);
            _noteOnMemory[touch.noteEvent.channel][touch.noteEvent.note] = true;
            notifyListeners();
          }
        }

        // handle AT

        // handle Slide

        // handle PB
      }
    }

    for (TouchEvent touch in touches.buffer) {
      if (touch.isDying) {
        touch.noteEvent.kill();
        _noteOnMemory[touch.noteEvent.channel][touch.noteEvent.note] = false;
        notifyListeners();
      }
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////
  // TOUCH HANDLING:
  push(PointerEvent touch, int note) {
    _touchBuffer.add(touch, note, getChannel(), _settings.velocity);
    updateMidi(_touchBuffer);
  }

  move(PointerEvent touch, int? note) {
    // check if it is a legeit event that has previously been registered by a push()
    TouchEvent? eventInBuffer = _touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    // check if previous events are dirty (by octave change):
    if (eventInBuffer.dirty) return;

    // update touchbuffer with this new event:
    _touchBuffer.updatePositionAndNote(touch, note);

    // update send buffer with updated touchbuffer
    updateMidi(_touchBuffer);
  }

  lift(PointerEvent touch) {
    // only send noteoff if there is a previous touch event,
    // which still has a note attached to it
    TouchEvent? eventInBuffer = _touchBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    // update send buffer with updated touchbuffer
    _touchBuffer.markDying(touch);
    updateMidi(_touchBuffer);
    _touchBuffer.remove(touch);
  }

  // DISPOSE:
  @override
  dispose() {
    if (_settings.playMode == PlayMode.mpe) {
      MPEinitMessage(memberChannels: 0, upperZone: _settings.upperZone);
    }
    for (int c = 0; c < 16; c++) {
      for (int note = 0; note < 128; note++) {
        if (_noteOnMemory[c][note]) {
          NoteOffMessage(
            channel: c,
            note: note,
          ).send();
          if (_settings.sendCC) {
            CCMessage(
              channel: (c + 1) % 16,
              controller: note,
            ).send();
          }
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
//////////////////////////////////////////////////////////////////////////////

// SEND BUFFER:
//   final List<NoteEvent> _sendBuffer =
//       List.List.generate(128, (_) => NoteEvent(), growable: false);

//   bool noteIsOn(int note) =>
//       note >= 0 && note < 128 ? _sendBuffer[note].noteIsOn : false;

//   void updateSendBufferAndSend(int note, bool noteOn) async {
//     if (noteOn) {
//       if (_settings.sendCC) {
//         CCMessage(
//           channel: (_settings.channel + 1) % 16,
//           controller: note,
//           value: 127,
//         ).send();
//       }
//       NoteOnMessage(
//         channel: note % 15 + 1, // TODO TEMP
//         note: note,
//         velocity: _settings.velocity,
//       ).send();

//       _sendBuffer[note] = NoteEvent(_settings.velocity);
//     } else {
//       if (_settings.sendCC) {
//         CCMessage(
//           channel: (_settings.channel + 1) % 16,
//           controller: note,
//         ).send();
//       }

//       // SUSTAIN:
//       if (_settings.sustainTimeUsable > 0) {
//         if (_sendBuffer[note].checkingSustain) return;
//         _sendBuffer[note].checkingSustain = true;

//         while (!await Future.delayed(
//           const Duration(milliseconds: 5),
//           () =>
//               DateTime.now().millisecondsSinceEpoch -
//                   _sendBuffer[note].triggerTime >
//               _settings.sustainTimeUsable,
//         )) {
//           // Waiting for next check in 5 milliseconds...
//         }
//         _sendBuffer[note].checkingSustain = false;
//       }
//       ////////////////

//       NoteOffMessage(
//         channel: note % 15 + 1, // TODO TEMP
//         note: note,
//         velocity: 0,
//       ).send();

//       _sendBuffer[note] = NoteEvent();
//     }

//     notifyListeners();
//   }

//   void updateSendBufferWithTouchBuffer() {
//     List<int> allCurrentlyTouched = _touchBuffer.buffer
//         .where((element) => element.note != null)
//         .map((element) => element.note!)
//         .toList();

//     for (int n = 0; n < 128; n++) {
//       if (allCurrentlyTouched.contains(n) && _sendBuffer[n].noteIsOff) {
//         updateSendBufferAndSend(n, true);
//       } else if (!allCurrentlyTouched.contains(n) && _sendBuffer[n].noteIsOn) {
//         updateSendBufferAndSend(n, false);
//       } else if (allCurrentlyTouched.contains(n) && _sendBuffer[n].noteIsOn) {
//         _sendBuffer[n].updateTriggerTime();
//       }
//     }
//   }
// }
