import 'package:beat_pads/devices/button_floating_pads.dart';
import 'package:beat_pads/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

// TODO: Bluetooth Midi?!

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
        title: Text("Select Midi Devices"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingButtonPads(),
      ),
      body: FutureBuilder(
        future: _midiCommand.devices,
        builder:
            ((BuildContext context, AsyncSnapshot<List<MidiDevice>?> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<MidiDevice>? _devices = snapshot.data;
            return connecting
                // WHILE CONNECTING:
                ? Center(
                    child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Palette.cadetBlue.color,
                    ),
                  ))
                :
                // WHEN NOT CONNECTING, SHOW LIST:
                ListView(
                    children: [
                      ..._devices!.map((device) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          color: device.connected
                              ? Palette.cadetBlue.color
                              : Palette.cadetBlue.color.withAlpha(40),
                          child: TextButton(
                            onPressed: () {
                              setDevice(device);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                device.name,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      InfoBox(
                        [
                          "1. Connect USB device (PC, Mac, IPad...)",
                          "2. Set USB mode to 'Midi' in Notification Menu",
                          "3. Refresh this Device List",
                          "4. Tap Device to Connect",
                        ],
                        header: "Midi Connection",
                      ),
                    ],
                  );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: Text("No Midi Devices Detected"));
          }
        }),
      ),
    );
  }

  // ? As in example. MidiCommand.dispose() only seems to dispose of bluetooth ressources?!
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
