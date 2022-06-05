import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services.dart';

final rxMidiStream = StreamProvider<MidiMessagePacket>(
  ((ref) async* {
    Stream<MidiPacket> rxStream =
        MidiCommand().onMidiDataReceived ?? const Stream.empty();

    int channel = ref.watch(settingsProvider.select((value) => value.channel));

    await for (MidiPacket packet in rxStream) {
      int statusByte = packet.data[0];

      if (statusByte & 0xF0 == 0xF0) continue; // filter: command messages
      if (statusByte & 0x0F != channel) continue; // filter: channel

      MidiMessageType type = MidiMessageType.fromStatusByte(statusByte);

      yield MidiMessagePacket(type, packet.data.skip(1).toList());
    }
  }),
);

final rxNoteProvider =
    StateNotifierProvider<RxNoteStateNotifier, List<int>>((ref) {
  // Listen to the stream itself instead of the value hold by the provider
  final midiStream = ref.watch(rxMidiStream.stream);

  // Create the instance of your StateNotifier
  final rxNoteProvider = RxNoteStateNotifier();

  /// Subscribe to the stream to change the state accordingly
  final subscription = midiStream.listen((message) {
    if (message.content.length < 2) return;

    if (message.type == MidiMessageType.noteOn) {
      rxNoteProvider.changeValue(message.content[0], message.content[1]);
    }
    if (message.type == MidiMessageType.noteOff) {
      rxNoteProvider.changeValue(message.content[0], 0);
    }
  });

  ref.onDispose(subscription.cancel); // Dispose to avoid memory leaks

  return rxNoteProvider;
});

class RxNoteStateNotifier extends StateNotifier<List<int>> {
  RxNoteStateNotifier() : super(List.filled(128, 0, growable: false));

  void changeValue(int note, int velocity) {
    state[note] = velocity;
    state = [...state];
  }

  void reset() {
    state = List.filled(128, 0, growable: false);
  }
}
