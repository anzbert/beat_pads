import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'dart:async';

import '../services.dart';

class MidiReceiver extends ChangeNotifier {
  StreamSubscription<MidiPacket>? _rxSubscription;
  final MidiCommand _midiCommand = MidiCommand();

  Settings _settings;

  MidiReceiver update(Settings settings) {
    _settings = settings;
    return this;
  }

  MidiReceiver(this._settings) {
    _rxSubscription = registerRxCallback();
  }

  // Received Notes Buffer:
  final List<int> _rxBuffer = List.filled(128, 0);
  List<int> get rxBuffer => _rxBuffer;

  int? modWheelValue;

  resetRxBuffer() {
    rxBuffer.fillRange(0, 128, 0);
    notifyListeners();
  }

  // Receiver Callback:
  StreamSubscription<MidiPacket>? registerRxCallback() {
    return _midiCommand.onMidiDataReceived?.listen((packet) {
      // print(
      //     "${packet.data} @ ${packet.timestamp} from ${packet.device.name} / ID:${packet.device.id}");

      int statusByte = packet.data[0];
      if (statusByte & 0xF0 != 0xF0 && statusByte & 0x0F != _settings.channel) {
        return;
      }

      MidiMessageType type = MidiUtils.getMidiMessageType(statusByte);

      // CC receiver for mod wheel:
      if (type == MidiMessageType.cc) {
        int controller = packet.data[1];
        int value = packet.data[2];

        if (controller == 1 && modWheelValue != value) {
          modWheelValue = 127 - value;
          notifyListeners();
        }
      }

      // note handling:
      if (type == MidiMessageType.noteOn || type == MidiMessageType.noteOff) {
        int note = packet.data[1];
        int velocity = packet.data[2];

        switch (type) {
          case MidiMessageType.noteOn:
            rxBuffer[note] = velocity;
            notifyListeners();
            break;
          case MidiMessageType.noteOff:
            rxBuffer[note] = 0;
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
