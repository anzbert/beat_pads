import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _connectedDevFuture = FutureProvider<List<MidiDevice>>((ref) async {
  return await MidiCommand().devices ?? [];
});

final connectedDevicesProv = Provider((ref) {
  return ref.watch(_connectedDevFuture).when(
        loading: () => [],
        error: (err, stack) => [],
        data: (deviceList) => deviceList,
      );
});
