import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import './main_menu.dart';

class MidiList extends StatelessWidget {
  const MidiList(this._midi, this.setDevice, {Key? key}) : super(key: key);

  final MidiCommand _midi;
  final Function setDevice;

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
        future: _midi.devices,
      ),
    );
  }
}
