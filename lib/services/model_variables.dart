import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class Variables extends ChangeNotifier {
  /// A Provider for non-persistent global working Variables
  Variables();

  Size padArea = Size(0, 0);

  List<MidiDevice> _connectedDevices = [];
  List<MidiDevice> get connectedDevices => _connectedDevices;
  set connectedDevices(List<MidiDevice> newVal) {
    _connectedDevices = newVal;
    notifyListeners();
  }
}
