import 'package:beat_pads/screen_midi_devices/button_refresh.dart';
import 'package:beat_pads/screen_midi_devices/help_text.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MidiConfig extends ConsumerStatefulWidget {
  const MidiConfig({Key? key}) : super(key: key);
  @override
  MidiConfigState createState() => MidiConfigState();
}

class MidiConfigState extends ConsumerState<MidiConfig> {
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
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
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
                        ref.refresh(devicesFuture);
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
                                  : Palette.darker(Palette.cadetBlue, 0.4),
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
                        ...helpText, // Text Boxes with Connection Information
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
