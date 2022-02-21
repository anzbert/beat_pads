import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import '../services/utils.dart';

import 'package:provider/provider.dart';
import 'soundboard_screen.dart';
import '../components/midi_dev_list.dart';

import '../state/settings.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final MidiCommand _midiCommand = MidiCommand();

  MidiDevice? currentDevice;

  void setDevice(MidiDevice device) {
    log("...connecting to : ${device.name}");

    if (currentDevice != null) _midiCommand.disconnectDevice(currentDevice!);

    _midiCommand.connectToDevice(device).then((_) => setState(() {
          currentDevice = device;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MidiList(_midiCommand, setDevice);
  }

  // dispose only seems to dispose of bluetooth ressources?!
  @override
  void dispose() {
    _midiCommand.dispose();
    super.dispose();
  }
}
