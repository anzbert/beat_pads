import 'package:beat_pads/screen_midi_devices/button_refresh.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'package:beat_pads/shared_components/_shared.dart';

import 'dart:io' show Platform;

import 'package:provider/provider.dart';

class MidiConfigState extends State<MidiConfig> {
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
        title: Text(
          "Devices",
          style: Theme.of(context).textTheme.headline5,
        ),
        // GradientText(
        //   'Devices',
        //   style: Theme.of(context).textTheme.headline4,
        //   colors: [
        //     // Palette.lightGrey,
        //     Palette.whiteLike,
        //     Palette.whiteLike,
        //     // Palette.lightPink,
        //     // Palette.cadetBlue,
        //     // Palette.laserLemon,
        //   ],
        // ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              // color: Palette.whiteLike,
              size: 30,
            ),
          );
        }),
        actions: [
          RefreshButton(
              onPressed: () => setState(() {}),
              icon: Icon(
                Icons.refresh,
                size: 30,
                color: Palette.laserLemon,
              )),
        ],
      ),
      body: FutureBuilder(
        future: _midiCommand.devices,
        builder:
            ((BuildContext context, AsyncSnapshot<List<MidiDevice>?> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<MidiDevice>? devices = snapshot.data;
            return connecting
                // WHILE CONNECTING SHOW CIRCULAR PROGRESS INDICATOR:
                ? Center(
                    child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Palette.cadetBlue,
                    ),
                  ))
                :
                // OTHERWISE, SHOW LIST:
                Builder(builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        context.read<Settings>().connectedDevices = [
                          ...devices!.where((element) => element.connected)
                        ];
                      },
                    );
                    return ListView(
                      children: [
                        if (devices!.isEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            color: Palette.lightPink,
                            height: 50,
                            child: Center(
                              child: Text(
                                "No Midi Adapter found...",
                                style: TextStyle(color: Palette.darkGrey),
                              ),
                            ),
                          ),
                        ...devices.map(
                          (device) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: device.connected
                                  ? Palette.cadetBlue
                                  : Palette.cadetBlue.withOpacity(0.1),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!,
                                      ),
                                      if (device.connected)
                                        const Icon(
                                          Icons.check,
                                          size: 24,
                                          color: Colors.white,
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (Platform.isAndroid)
                          const TextInfoBox(
                            header: "USB",
                            body: [
                              "Connect USB cable to Host Device",
                              "Slide down the Notification Menu and set the USB connection mode to 'Midi'",
                              "If there is no Midi option available, your Android phone may only show this setting in the Developer Menu. Please refer to readily available instructions online on how to access this Menu on your Device",
                              "Once Midi mode is activated, refresh this Device List",
                              "Tap USB Device to Connect",
                              "",
                              "",
                              "Note: The Developer menu allows you to set the default USB connection mode to Midi",
                            ],
                          ),
                        if (Platform.isIOS)
                          const TextInfoBox(
                            header: "USB",
                            body: [
                              "Connect USB cable to Host Device",
                              "Open 'Audio MIDI Setup' on Mac and click 'Enable' under iPad/iPhone in the 'Audio Devices' Window",
                              "Refresh this Device List",
                              "Tap 'IDAM MIDI Host' to Connect",
                              "",
                              "",
                              "Note: USB without third-party adapters works only with MacOS devices, due to Apple's MIDI implementation!",
                            ],
                          ),
                        if (Platform.isIOS)
                          const TextInfoBox(
                            header: "WiFi",
                            body: [
                              "Connect to same WiFi as Host Device",
                              "Connect to 'Network Session 1' in this Device List",
                              "Open 'Audio MIDI Setup' on Mac and open the 'MIDI Studio' window",
                              "Create a Session in the 'MIDI Network Setup' window and connect to your iPad/iPhone",
                              "",
                              "",
                              "Note: Wireless Protocols add Latency. Connection to Windows Hosts via WiFi requires third-party Software (like Apple rtpMIDI)"
                            ],
                          ),
                      ],
                    );
                  });
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: Text("No Midi Devices Detected"));
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
  MidiConfigState createState() => MidiConfigState();
}
