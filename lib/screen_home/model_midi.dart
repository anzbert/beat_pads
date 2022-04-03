import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'dart:async';

import '../services/_services.dart';

class MidiData extends ChangeNotifier {
// public:
  final List<int> rxNotes = List.filled(128, 0);

  rxNotesReset() {
    rxNotes.fillRange(0, 128, 0);
    notifyListeners();
  }

  int _channel = 0;
  set channel(int channel) {
    if (channel < 0 || channel > 15) return;
    _channel = channel;
    notifyListeners();
  }

  int get channel => _channel;
  resetChannel() => channel = 0;

// private:
  StreamSubscription<MidiPacket>? _rxSubscription;
  final MidiCommand _midiCommand = MidiCommand();

// constructor:
  MidiData() {
    _rxSubscription = _midiCommand.onMidiDataReceived?.listen((packet) {
      int header = packet.data[0];

      // print(
      //     "${packet.data} @ ${packet.timestamp} from ${packet.device.name} / ID:${packet.device.id}");

      // If the message is NOT a command (0xFn), and NOT using the correct channel -> return:
      if (header & 0xF0 != 0xF0 && header & 0x0F != _channel) return;

      MidiMessageType type = MidiUtils.getMidiMessageType(header);

      if (type == MidiMessageType.noteOn || type == MidiMessageType.noteOff) {
        // Data only handling noteON(9) and noteOFF(8) at the moment:
        int note = packet.data[1];
        int velocity = packet.data[2];

        switch (type) {
          case MidiMessageType.noteOn:
            rxNotes[note] = velocity;
            notifyListeners();
            break;
          case MidiMessageType.noteOff:
            rxNotes[note] = 0;
            notifyListeners();
            break;
          default:
            return;
        }
      }
    });
  }

  @override
  void dispose() {
    _rxSubscription?.cancel();
    super.dispose();
  }
}
