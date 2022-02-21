import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import '../services/utils.dart';
import '../components/main_menu.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Midi Device"),
      ),
      drawer: Drawer(
        child: MainMenu(),
      ),
      body: FutureBuilder(
        future: _midiCommand.devices,
        builder:
            ((BuildContext context, AsyncSnapshot<List<MidiDevice>?> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<MidiDevice>? _devices = snapshot.data;
            return ListView(
              children: _devices!.map((device) {
                return TextButton(
                  onPressed: () {
                    setDevice(device);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(device.name),
                  ),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: Text("No Midi Devices Detected"));
          }
        }),
      ),
    );
  }

  // MidiCommand.dispose() only seems to dispose of bluetooth ressources?!
  @override
  void dispose() {
    _midiCommand.dispose();
    super.dispose();
  }
}

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}
