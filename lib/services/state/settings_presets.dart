import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final presetNotifierProvider = NotifierProvider<PresetNotfier, int>(() {
  return PresetNotfier();
});

class PresetNotfier extends Notifier<int> {
  static const int numberOfPresets = 5;
  static const int basePreset = 1;

  @override
  int build() {
    return basePreset;
  }

  /// Set to a Preset between [basePreset] and [numberOfPresets]
  void set(int newPreset) {
    ref.read(senderProvider).killAllNotes();
    state = newPreset.clamp(basePreset, numberOfPresets);
  }
}
