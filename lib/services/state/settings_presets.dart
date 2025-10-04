import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final presetNotifierProvider = NotifierProvider<PresetNotfier, int>(() {
  return PresetNotfier();
});

class PresetNotfier extends SettingIntNotifier {
  static const int numberOfPresets = 5;
  static const int basePreset = 1;

  PresetNotfier({
    super.min = basePreset,
    super.max = numberOfPresets,
    super.key = 'last_preset',
    super.defaultValue = basePreset,
    super.resettable = false,
    super.usesPresets = false,
  });

  /// Set to a Preset between [basePreset] and [numberOfPresets]
  @override
  void setAndSave(int newPreset) {
    // ref.read(senderProvider.notifier).playModeHandler.killAllNotes();

    super.setAndSave(newPreset.clamp(basePreset, numberOfPresets));
  }
}
