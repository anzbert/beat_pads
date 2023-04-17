import 'package:beat_pads/main.dart';
import 'package:beat_pads/services/settings/settings_presets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds an instance of the loaded [SharedPreferences]
class Prefs {
  Prefs._();
  late SharedPreferences sharedPrefs;

  static Future<Prefs> initAsync() async {
    final instance = Prefs._()
      ..sharedPrefs = await SharedPreferences.getInstance();
    return instance;
  }
}

/// Call ``resetAll()`` on this [Notifier] to alert all [SettingNotifier]s
/// to reset themselves
final resetAllProv = NotifierProvider<_ResetAllNotifier, bool>(
  _ResetAllNotifier.new,
);

class _ResetAllNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// Causes a change in state, which alerts all listeners of this [Notifier].
  void resetAll() {
    state = !state;
  }

  void resetAllPresets() {
    for (var i = PresetNotfier.numberOfPresets; i >= 1; i--) {
      ref.read(presetNotifierProvider.notifier).set(i);
      resetAll();
    }
  }
}

abstract class SettingNotifier<T> extends Notifier<T> {
  SettingNotifier({
    required this.key,
    required this.defaultValue,
    this.usesPresets = true,
    this.resettable = true,
  }) : presetKey = '{$key}-${PresetNotfier.basePreset}';
  final T defaultValue;
  final String key;
  String presetKey;
  final bool usesPresets;
  final bool resettable;

  /// Set this Settings state to a new value
  // ignore: use_setters_to_change_properties
  void set(T newState) {
    state = newState;
  }

  /// Set this Settings state to a new value and save it to
  /// the [SharedPreferences]
  void setAndSave(T newState) {
    set(newState);
    save();
  }

  /// Register a Listener to the [resetAllProv] and reset this Setting when
  /// alerted by this provider.
  void _registerListeners() {
    if (resettable) {
      ref.listen(resetAllProv, (prev, next) {
        if (prev != next) reset();
      });
    }
    if (usesPresets) {
      ref.listen(presetNotifierProvider, (_, next) {
        presetKey = '{$key}-$next';
        state = _load();
      });
    }
  }

  /// Permanently reset this Setting to the default value.
  void reset() {
    set(defaultValue);
    save();
  }

  /// Fetch value from [SharedPreferences]
  T _load();

  /// Save the current State of this Setting to the [SharedPreferences]
  void save();
}

class SettingIntNotifier extends SettingNotifier<int> {
  SettingIntNotifier({
    required this.max,
    required super.defaultValue,
    required super.key,
    this.min = 0,
    super.resettable,
    super.usesPresets,
  });
  final int min;
  final int max;

  @override
  Future<void> save() async {
    await ref.read(sharedPrefProvider).sharedPrefs.setInt(presetKey, state);
  }

  void increment() => set(state + 1);
  void decrement() => set(state - 1);

  @override
  void set(int newState) {
    state = newState.clamp(min, max);
  }

  @override
  int _load() =>
      ref.read(sharedPrefProvider).sharedPrefs.getInt(presetKey) ??
      defaultValue;

  @override
  int build() {
    _registerListeners();
    return _load();
  }
}

class SettingBoolNotifier extends SettingNotifier<bool> {
  SettingBoolNotifier({
    required super.key,
    required super.defaultValue,
    super.resettable,
    super.usesPresets,
  });

  @override
  bool build() {
    _registerListeners();
    return _load();
  }

  @override
  Future<void> save() async {
    await ref.read(sharedPrefProvider).sharedPrefs.setBool(presetKey, state);
  }

  Future<void> toggleAndSave() async {
    state = !state;
    await save();
  }

  @override
  bool _load() =>
      ref.read(sharedPrefProvider).sharedPrefs.getBool(presetKey) ??
      defaultValue;
}

class SettingDoubleNotifier extends SettingNotifier<double> {
  SettingDoubleNotifier({
    required this.max,
    required super.key,
    required super.defaultValue,
    this.min = 0,
    super.resettable,
    super.usesPresets,
  });
  final double min;
  final double max;

  @override
  void set(double newState) {
    state = newState.clamp(min, max);
  }

  @override
  Future<void> save() async {
    await ref
        .read(sharedPrefProvider)
        .sharedPrefs
        .setInt(presetKey, (state * 100).toInt());
  }

  @override
  double build() {
    _registerListeners();
    return _load();
  }

  @override
  double _load() {
    final value = ref.read(sharedPrefProvider).sharedPrefs.getInt(presetKey);
    return value != null ? value / 100 : defaultValue;
  }
}

class SettingStringNotifier extends SettingNotifier<String> {
  SettingStringNotifier({
    required super.key,
    required super.defaultValue,
    super.resettable,
    super.usesPresets,
  });

  @override
  Future<void> save() async {
    await ref.read(sharedPrefProvider).sharedPrefs.setString(presetKey, state);
  }

  @override
  String build() {
    _registerListeners();
    return _load();
  }

  @override
  String _load() =>
      ref.read(sharedPrefProvider).sharedPrefs.getString(presetKey) ??
      defaultValue;
}

class SettingEnumNotifier<T extends Enum> extends SettingNotifier<T> {
  SettingEnumNotifier({
    required this.nameMap,
    required super.key,
    required super.defaultValue,
    super.resettable,
    super.usesPresets,
  });
  final Map<String, T> nameMap;

  @override
  Future<void> save() async {
    await ref
        .read(sharedPrefProvider)
        .sharedPrefs
        .setString(presetKey, state.name);
  }

  @override
  T build() {
    _registerListeners();
    return _load();
  }

  @override
  T _load() {
    final name = ref.read(sharedPrefProvider).sharedPrefs.getString(presetKey);
    if (name != null) {
      final value = nameMap[name];
      if (value != null) return value;
    }
    return defaultValue;
  }
}
