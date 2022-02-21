import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import './services/utils.dart';

import 'package:provider/provider.dart';
import './soundboard.dart';
import './midilist.dart';

import './settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MidiCommand _midiCommand = MidiCommand();

  MidiDevice? currentDevice;

  void setDevice(MidiDevice device) {
    log("...connecting to : ${device.name}");

    _midiCommand.connectToDevice(device).then((_) => setState(() {
          currentDevice = device;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Settings(),
      child: currentDevice == null
          ? MidiList(_midiCommand, setDevice)
          : SoundBoard(),
    );
  }

  @override
  void dispose() {
    _midiCommand.dispose();
    super.dispose();
  }
}
