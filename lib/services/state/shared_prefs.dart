import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

final resetAllProv = NotifierProvider<_ResetAllNotifier, bool>(
  () => _ResetAllNotifier(),
);

class _ResetAllNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void resetAll() {
    state = !state;
  }
}

class Prefs {
  Prefs._();
  late SharedPreferences sharedPrefs;

  static Future<Prefs> initAsync() async {
    Prefs instance = Prefs._();
    instance.sharedPrefs = await SharedPreferences.getInstance();
    return instance;
  }
}

abstract class Setting<T> extends Notifier<T> {
  Setting({required this.key, required this.defaultValue}) {
    ref.listen(resetAllProv, (_, next) {
      reset();
    });
  }

  final T defaultValue;
  final String key;

  void set(T newState) {
    state = newState;
  }

  void setAndSave(T newState) {
    set(newState);
    save();
  }

  void reset() {
    set(defaultValue);
    save();
  }

  Future<bool> save();
}

class SettingBoolNotifier extends Setting<bool> {
  SettingBoolNotifier({
    required key,
    required defaultValue,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  bool build() {
    bool? value = ref.read(sharedPrefProvider).sharedPrefs.getBool(key);
    if (value != null) {
      return value;
    } else {
      return defaultValue;
    }
  }

  @override
  Future<bool> save() async {
    return await ref.read(sharedPrefProvider).sharedPrefs.setBool(key, state);
  }

  void toggleAndSave() {
    state = !state;
    save();
  }
}

class SettingIntNotifier extends Setting<int> {
  final int min;
  final int max;

  SettingIntNotifier({
    required key,
    required defaultValue,
    required this.max,
    this.min = 0,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  Future<bool> save() async {
    return await ref.read(sharedPrefProvider).sharedPrefs.setInt(key, state);
  }

  void increment() => set(state + 1);
  void decrement() => set(state - 1);

  @override
  void set(int newState) {
    state = newState.clamp(min, max);
  }

  @override
  int build() {
    int? value = ref.read(sharedPrefProvider).sharedPrefs.getInt(key);
    if (value != null) {
      return value;
    } else {
      return defaultValue;
    }
  }
}

class SettingDoubleNotifier extends Setting<double> {
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
  Future<bool> save() async {
    return await ref
        .read(sharedPrefProvider)
        .sharedPrefs
        .setInt(key, (state * 100).toInt());
  }

  @override
  double build() {
    int? value = ref.read(sharedPrefProvider).sharedPrefs.getInt(key);
    if (value != null) {
      return value / 100;
    } else {
      return defaultValue;
    }
  }
}

class SettingStringNotifier extends Setting<String> {
  SettingStringNotifier({
    required key,
    required defaultValue,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  Future<bool> save() async {
    return await ref.read(sharedPrefProvider).sharedPrefs.setString(key, state);
  }

  @override
  String build() {
    String? value = ref.read(sharedPrefProvider).sharedPrefs.getString(key);
    if (value != null) {
      return value;
    } else {
      return defaultValue;
    }
  }
}

typedef FromName<T> = T? Function(String);

class SettingEnumNotifier<T extends Enum> extends Setting<T> {
  final FromName<T> fromName;

  SettingEnumNotifier({
    required this.fromName,
    required key,
    required defaultValue,
  }) : super(defaultValue: defaultValue, key: key);

  @override
  Future<bool> save() async {
    return await ref
        .read(sharedPrefProvider)
        .sharedPrefs
        .setString(key, state.name);
  }

  @override
  T build() {
    String? name = ref.read(sharedPrefProvider).sharedPrefs.getString(key);
    if (name != null) {
      T? value = fromName(name);
      if (value != null) return value;
    }
    return defaultValue;
  }
}
