import 'package:beat_pads/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services.dart';

final rxNoteProvider = StateNotifierProvider<ReceivedState, List<int>>((ref) {
  //Listen to the stream itself instead of the value hold by the provider
  final midiStream = ref.watch(rxMidiStream.stream);

  //Create the instance of your StateNotifier
  final rxNoteProvider = ReceivedState();

  /// subscribe to the stream to change the state accordingly
  final subscription = midiStream.listen((message) {
    if (message.content.length < 2) return;

    if (message.type == MidiMessageType.noteOn) {
      rxNoteProvider.changeValue(message.content[0], message.content[1]);
    }
    if (message.type == MidiMessageType.noteOff) {
      rxNoteProvider.changeValue(message.content[0], 0);
    }
  });

  ref.onDispose(subscription.cancel); // dispose to avoid memory leaks

  return rxNoteProvider;
});

class ReceivedState extends StateNotifier<List<int>> {
  ReceivedState() : super(List.filled(128, 0, growable: false));

  void changeValue(int note, int velocity) {
    state[note] = velocity;
    state = [...state];
  }

  void reset() {
    state = List.filled(128, 0, growable: false);
  }
}
