import 'package:flutter_riverpod/flutter_riverpod.dart';

final presetNotifierProvider = NotifierProvider<PresetNotfier, int>(() {
  return PresetNotfier();
});

class PresetNotfier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }
}
