import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class NoteReceiver extends ChangeNotifier {
  final notesArray = List.filled(128, Colors.green);

  StreamSubscription<MidiPacket>? _rxSubscription;
  final MidiCommand _midiCommand = MidiCommand();

  NoteReceiver() {
    _rxSubscription = _midiCommand.onMidiDataReceived?.listen((packet) {
      // print("data: ${packet.data} @ time ${packet.timestamp} from device ${packet.device.name}:${packet.device.id}");
      int status = packet.data[0] >> 4;

      if (packet.data.length > 1) {
        int note = packet.data[1];
        // int channel = packet.data[0] & 0x0F;

        if (status == 9) {
          // noteON
          notesArray[note] = Colors.amber;
          notifyListeners();
        } else if (status == 8) {
          // noteOFF
          notesArray[note] = Colors.green;
          notifyListeners();
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
