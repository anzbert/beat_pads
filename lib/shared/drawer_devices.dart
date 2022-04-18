import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'package:beat_pads/shared/_shared.dart';

import 'dart:io' show Platform;

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
                    width: 50,
                    height: 50,
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
                      if (Platform.isAndroid)
                        TextInfoBox(
                          header: "USB Setup",
                          body: [
                            "Connect USB cable to Host Device",
                            "Slide down the Notification Menu and set the USB connection mode to 'Midi'",
                            "Refresh this Device List",
                            "Tap USB Device to Connect",
                          ],
                        ),
                      if (Platform.isIOS)
                        TextInfoBox(
                          header: "USB Setup",
                          body: [
                            "Connect USB cable to Host Device",
                            "Open 'Audio MIDI Setup' on Mac and click 'Enable' under iPad/iPhone in the 'Audio Devices' Window",
                            "Refresh this Device List",
                            "Tap 'IDAM MIDI Host' to Connect",
                            "",
                            "Note: USB connection ONLY works with MacOS devices due to Apple's MIDI implementation!",
                          ],
                        ),
                      if (Platform.isIOS)
                        TextInfoBox(
                          header: "WiFi Setup",
                          body: [
                            "Connect to same WiFi as Host Device",
                            "Connect to 'Network Session 1' in this Device List",
                            "Open 'Audio MIDI Setup' on Mac and open the 'MIDI Studio' window",
                            "Create a Session in the 'MIDI Network Setup' window and connect to your iPad/iPhone",
                            "",
                            "Note: Wireless Midi Protocols add Latency. Connection to Windows Hosts via WiFi requires third-party Software"
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
