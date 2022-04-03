import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'package:beat_pads/shared/_shared.dart';

class _MidiConfigState extends State<MidiConfig> {
  final MidiCommand _midiCommand = MidiCommand();

  bool connecting = false;

  void setDevice(MidiDevice device) {
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
        title: Text("Select Devices"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: _midiCommand.devices,
        builder:
            ((BuildContext context, AsyncSnapshot<List<MidiDevice>?> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<MidiDevice>? _devices = snapshot.data;
            return connecting
                // WHILE CONNECTING SHOW CIRCULAR PROGRESS INDICATOR:
                ? Center(
                    child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Palette.cadetBlue.color,
                    ),
                  ))
                :
                // OTHERWISE, SHOW LIST:
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
                            child: SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    device.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  if (device.connected)
                                    Icon(
                                      Icons.check,
                                      size: 24,
                                      color: Colors.white,
                                    )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      InfoBox(
                        [
                          "1. Connect USB Host Device",
                          "2. Set USB connection mode to 'Midi' in Notification Menu",
                          "3. Refresh this Device List",
                          "4. Tap Device to Connect",
                        ],
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

  // As in example. MidiCommand.dispose() only seems to dispose of bluetooth ressources?!
  // Disposing anyway, just to be sure.
  @override
  void dispose() {
    _midiCommand.dispose();
    super.dispose();
  }
}

class MidiConfig extends StatefulWidget {
  const MidiConfig({Key? key}) : super(key: key);
  @override
  _MidiConfigState createState() => _MidiConfigState();
}
