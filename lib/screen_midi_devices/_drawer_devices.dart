import 'dart:async';

import 'package:beat_pads/screen_midi_devices/button_refresh.dart';
import 'package:beat_pads/screen_midi_devices/help_text.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MidiConfig extends ConsumerStatefulWidget {
  const MidiConfig({super.key});
  @override
  MidiConfigState createState() => MidiConfigState();
}

class MidiConfigState extends ConsumerState<MidiConfig> {
  StreamSubscription<String>? _setupSubscription;
  StreamSubscription<BluetoothState>? _bluetoothStateSubscription;
  final MidiCommand _midiCommand = MidiCommand();
  bool connecting = false;

  // bool _didAskForBluetoothPermissions = false;
  // Future<void> _informUserAboutBluetoothPermissions(
  //     BuildContext context) async {
  //   if (_didAskForBluetoothPermissions) {
  //     return;
  //   }
  //   await showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title:
  //             const Text('Bluetooth Permission to discover BLE MIDI Devices'),
  //         content: const Text(
  //             'In the next dialog we might ask you for the permission to use Bluetooth.\n'
  //             'Please grant this permission to make Bluetooth MIDI possible.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Ok. I got it!'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //   _didAskForBluetoothPermissions = true;
  //   return;
  // }

  // bool _iOSNetworkSessionEnabled = false;
  // void _updateNetworkSessionState() async {
  //   var nse = await _midiCommand.isNetworkSessionEnabled;
  //   if (nse != null) {
  //     setState(() {
  //       _iOSNetworkSessionEnabled = nse;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();

    _setupSubscription = _midiCommand.onMidiSetupChanged?.listen((data) async {
      if (kDebugMode) {
        print("setup changed $data");
      }
      setState(() {});
    });

    _bluetoothStateSubscription =
        _midiCommand.onBluetoothStateChanged.listen((data) {
      if (kDebugMode) {
        print("bluetooth state change $data");
      }
      setState(() {});
    });

    // _updateNetworkSessionState();

    _midiCommand.setNetworkSessionEnabled(true);
  }

  // As in example. MidiCommand.dispose() only seems to dispose of bluetooth ressources?!
  // Disposing anyway, just to be sure.
  @override
  void dispose() {
    _setupSubscription?.cancel();
    _bluetoothStateSubscription?.cancel();
    _midiCommand.dispose();
    super.dispose();
  }

  void setDevice(MidiDevice device) {
    if (device.connected) {
      _midiCommand.disconnectDevice(device);
      setState(() {});
    } else {
      setState(() {
        connecting = true;
      });
      _midiCommand.connectToDevice(device).then(
            (_) => setState(() {
              connecting = false;
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Devices',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Palette.lightPink),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Palette.lightPink,
                size: 30,
              ),
            );
          },
        ),
        actions: [
          RefreshButton(
            onPressed: () async {
              // Ask for bluetooth permissions
              // await _informUserAboutBluetoothPermissions(context);

              // Start bluetooth
              if (kDebugMode) {
                print("start ble central");
              }
              await _midiCommand.startBluetoothCentral().catchError((err) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(err),
                  ));
                }
              });

              if (kDebugMode) {
                print("wait for init");
              }
              await _midiCommand
                  .waitUntilBluetoothIsInitialized()
                  .timeout(const Duration(seconds: 5), onTimeout: () {
                if (kDebugMode) {
                  print("Failed to initialize Bluetooth");
                }
              });

              // If bluetooth is powered on, start scanning
              if (_midiCommand.bluetoothState == BluetoothState.poweredOn) {
                _midiCommand
                    .startScanningForBluetoothDevices()
                    .catchError((err) {
                  if (kDebugMode) {
                    print("Error $err");
                  }
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Scanning for bluetooth devices ...'),
                  ));
                }
              } else {
                final messages = {
                  BluetoothState.unsupported:
                      'Bluetooth is not supported on this device.',
                  BluetoothState.poweredOff:
                      'Please switch on bluetooth and try again.',
                  BluetoothState.poweredOn: 'Everything is fine.',
                  BluetoothState.resetting:
                      'Currently resetting. Try again later.',
                  BluetoothState.unauthorized:
                      'This app needs bluetooth permissions. Please open settings, find your app and assign bluetooth access rights and start your app again.',
                  BluetoothState.unknown:
                      'Bluetooth is not ready yet. Try again later.',
                  BluetoothState.other:
                      'This should never happen. Please inform the developer of your app.',
                };
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(messages[_midiCommand.bluetoothState] ??
                        'Unknown bluetooth state: ${_midiCommand.bluetoothState}'),
                  ));
                }
              }

              if (kDebugMode) {
                print("BL scanning done");
              }
              // If not show a message telling users what to do
              setState(() {});
            },
            icon: Icon(
              Icons.refresh,
              size: 30,
              color: Palette.lightPink,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: FutureBuilder(
              future: _midiCommand.devices,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<MidiDevice>?> snapshot,
              ) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final List<MidiDevice>? devices = snapshot.data;
                  return connecting
                      // WHILE CONNECTING SHOW CIRCULAR PROGRESS INDICATOR:
                      ? Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: Palette.cadetBlue,
                            ),
                          ),
                        )
                      :
                      // OTHERWISE, SHOW LIST:
                      Builder(
                          builder: (context) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                ref.invalidate(devicesFutureProv);
                              },
                            );
                            return Column(
                              children: [
                                if (devices!.isEmpty)
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    color: Palette.lightPink,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        'No Midi Adapter found...',
                                        style:
                                            TextStyle(color: Palette.darkGrey),
                                      ),
                                    ),
                                  ),
                                ...devices.map(
                                  (device) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      color: device.connected
                                          ? Palette.cadetBlue
                                          : Palette.darker(
                                              Palette.cadetBlue,
                                              0.4,
                                            ),
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
                                                    .titleMedium,
                                              ),
                                              if (device.connected)
                                                const Icon(
                                                  Icons.check,
                                                  size: 24,
                                                  color: Colors.white,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(
                    child: Text('- No Midi Devices Detected -'),
                  );
                }
              },
            ),
          ),
          ...helpText,
        ],
      ),
    );
  }
}
