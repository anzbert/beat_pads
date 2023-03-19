import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services.dart';

/// Wraps the FlutterMidiCommand onMidiDataReceived Stream in a Streamprovider
final rxMidiStream = StreamProvider<MidiMessagePacket>(
  ((ref) async* {
    Stream<MidiPacket> rxStream =
        MidiCommand().onMidiDataReceived ?? const Stream.empty();

    int channel = ref.watch(channelUsableProv);

    await for (MidiPacket packet in rxStream) {
      int statusByte = packet.data[0];

      if (statusByte & 0xF0 == 0xF0) continue; // filter: command messages
      if (statusByte & 0x0F != channel) continue; // filter: channel

      MidiMessageType type = MidiMessageType.fromStatusByte(statusByte);

      yield MidiMessagePacket(type, packet.data.skip(1).toList());
    }
  }),
);

/// This provider holds a list of velocities of all received midi notes in the
/// currently selected master channel
final rxNoteProvider =
    NotifierProvider<_RxNoteVelocitiesNotifier, List<int>>(() {
  return _RxNoteVelocitiesNotifier();
});

class _RxNoteVelocitiesNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    ref.listen(rxMidiStream,
        (AsyncValue<MidiMessagePacket>? _, AsyncValue<MidiMessagePacket> next) {
      if (next.hasError || next.hasValue == false || next.value == null) return;
      if (next.value!.content.length < 2) return; // message too short

      if (next.value!.type == MidiMessageType.noteOn) {
        changeValue(next.value!.content[0], next.value!.content[1]);
      }
      if (next.value!.type == MidiMessageType.noteOff) {
        changeValue(next.value!.content[0], 0);
      }
    });

    return List.filled(128, 0, growable: false);
  }

  void changeValue(int note, int velocity) {
    if (state[note] != velocity) {
      state[note] = velocity;
      state = [...state];
    }
  }

  void reset() {
    state = List.filled(128, 0, growable: false);
  }
}
