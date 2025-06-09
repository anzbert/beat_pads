import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Maybe use an applifecyclelistener to reconnect to previously connected midi devices after inacitivity (seems to be an issue on iOS) - might not be an issue any more?!
// probably best with this: https://api.flutter.dev/flutter/widgets/AppLifecycleListener-class.html

final devicesFutureProv = FutureProvider<List<MidiDevice>?>((ref) async {
  return MidiCommand().devices;
});

final connectedDevicesProv = Provider<List<MidiDevice>>((ref) {
  return ref.watch(devicesFutureProv).when(
        loading: () => [],
        error: (err, stack) => [],
        data: (deviceList) => deviceList == null
            ? []
            : [...deviceList.where((element) => element.connected)],
      );
});
