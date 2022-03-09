import 'package:beat_pads/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import '../components/main_menu.dart';

class _ConfigScreenState extends State<ConfigScreen> {
  final MidiCommand _midiCommand = MidiCommand();

  bool connecting = false;

  void setDevice(MidiDevice device) {
    // print("BP: Connecting to : ${device.name}");

    if (device.connected) {
      _midiCommand.disconnectDevice(device);
      setState(() {});
    } else {
      setState(() {
        connecting = true;
      });
      _midiCommand.connectToDevice(device).then((_) => setState(() {
            connecting = false;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Midi Device"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
      drawer: Drawer(
        child: MainMenu(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton.large(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.view_comfortable_rounded,
            size: 50,
          ),
          onPressed: (() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }),
        ),
      ),
      body: FutureBuilder(
        future: _midiCommand.devices,
        builder:
            ((BuildContext context, AsyncSnapshot<List<MidiDevice>?> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<MidiDevice>? _devices = snapshot.data;
            return connecting
                ? Center(
                    child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Colors.grey[400],
                    ),
                  ))
                : ListView(
                    children: _devices!.map((device) {
                      return Container(
                        color: device.connected
                            ? Colors.green[800]
                            : Colors.transparent,
                        child: TextButton(
                          onPressed: () {
                            setDevice(device);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              device.name,
                              style: TextStyle(
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
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

  // ? MidiCommand.dispose() only seems to dispose of bluetooth ressources?!
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
