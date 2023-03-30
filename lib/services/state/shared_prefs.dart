import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

/// Holds an instance of the loaded [SharedPreferences]
class Prefs {
  Prefs._();
  late SharedPreferences sharedPrefs;

  static Future<Prefs> initAsync() async {
    Prefs instance = Prefs._();
    instance.sharedPrefs = await SharedPreferences.getInstance();
    return instance;
  }
}

/// Call ``resetAll()`` on this [Notifier] to alert all [SettingNotifier]s to reset themselves
final resetAllProv = NotifierProvider<_ResetAllNotifier, bool>(
  () => _ResetAllNotifier(),
);

class _ResetAllNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  /// Causes a change in state, which alerts all listeners of this [Notifier].
  void resetAll() {
    state = !state;
  }
}

abstract class SettingNotifier<T> extends Notifier<T> {
  final T defaultValue;
  final String key;

  SettingNotifier({required this.key, required this.defaultValue});

  void set(T newState) {
    state = newState;
  }

  void setAndSave(T newState) {
    set(newState);
    save();
  }

  void _registerResetAllListener() {
    ref.listen(resetAllProv, (prev, next) {
      if (prev != next) reset();
    });
  }

  void reset() {
    set(defaultValue);
    save();
  }

  void save();
}

class SettingIntNotifier extends SettingNotifier<int> {
  final int min;
  final int max;

  SettingIntNotifier({
    required key,
    required defaultValue,
    required this.max,
    this.min = 0,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  void save() async {
    await ref.read(sharedPrefProvider).sharedPrefs.setInt(key, state);
  }

  void increment() => set(state + 1);
  void decrement() => set(state - 1);

  @override
  void set(int newState) {
    state = newState.clamp(min, max);
  }

  @override
  int build() {
    _registerResetAllListener();

    int? value = ref.read(sharedPrefProvider).sharedPrefs.getInt(key);
    if (value != null) {
      return value;
    } else {
      return defaultValue;
    }
  }
}

class SettingBoolNotifier extends SettingNotifier<bool> {
  SettingBoolNotifier({
    required key,
    required defaultValue,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  bool build() {
    _registerResetAllListener();

    bool? value = ref.read(sharedPrefProvider).sharedPrefs.getBool(key);
    if (value != null) {
      return value;
    } else {
      return defaultValue;
    }
  }

  @override
  void save() async {
    await ref.read(sharedPrefProvider).sharedPrefs.setBool(key, state);
  }

  void toggleAndSave() {
    state = !state;
    save();
  }
}

class SettingDoubleNotifier extends SettingNotifier<double> {
  final double min;
  final double max;

  SettingDoubleNotifier({
    required key,
    required defaultValue,
    this.min = 0,
    required this.max,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  void set(double newState) {
    state = newState.clamp(min, max);
  }

  @override
  void save() async {
    await ref
        .read(sharedPrefProvider)
        .sharedPrefs
        .setInt(key, (state * 100).toInt());
  }

  @override
  double build() {
    _registerResetAllListener();

    int? value = ref.read(sharedPrefProvider).sharedPrefs.getInt(key);
    if (value != null) {
      return value / 100;
    } else {
      return defaultValue;
    }
  }
}

class SettingStringNotifier extends SettingNotifier<String> {
  SettingStringNotifier({
    required key,
    required defaultValue,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  void save() async {
    await ref.read(sharedPrefProvider).sharedPrefs.setString(key, state);
  }

  @override
  String build() {
    _registerResetAllListener();

    String? value = ref.read(sharedPrefProvider).sharedPrefs.getString(key);
    if (value != null) {
      return value;
    } else {
      return defaultValue;
    }
  }
}

typedef FromName<T> = T? Function(String);

class SettingEnumNotifier<T extends Enum> extends SettingNotifier<T> {
  final FromName<T> fromName;

  SettingEnumNotifier({
    required this.fromName,
    required key,
    required defaultValue,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  void save() async {
    await ref.read(sharedPrefProvider).sharedPrefs.setString(key, state.name);
  }

  @override
  T build() {
    _registerResetAllListener();

    String? name = ref.read(sharedPrefProvider).sharedPrefs.getString(key);
    if (name != null) {
      T? value = fromName(name);
      if (value != null) return value;
    }
    return defaultValue;
  }
}
