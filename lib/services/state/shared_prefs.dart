import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class Prefs {
  Prefs._();
  late SharedPreferences sharedPrefs;

  static Future<Prefs> initAsync() async {
    Prefs instance = Prefs._();
    instance.sharedPrefs = await SharedPreferences.getInstance();
    return instance;
  }
}

// scale = SettingEnumNotifier<Scale>(
//   fromName: Scale.fromName,
//   key: 'scaleString',
//   defaultValue: Scale.chromatic,
// ),

//   rootNote = SettingIntNotifier(
//     key: 'rootNote',
//  defaultValue:    0,
//     max: 11,
//   ),

//   width = SettingIntNotifier(
//     key: 'width',
//  defaultValue:    4,
//     min: 2,
//     max: 16,
//   ),
//   height = SettingIntNotifier(
//     key: 'height',
//  defaultValue:    4,
//     min: 2,
//     max: 16,
//   ),

abstract class Setting<T> extends Notifier<T> {
  void set(T newState) {
    state = newState;
  }

  void setAndSave(T newState) {
    set(newState);
    save();
  }

  void reset();

  Future<bool> save();
}

class SettingBoolNotifier extends Setting<bool> {
  SettingBoolNotifier({
    required this.key,
    required this.defaultValue,
  });

  final String key;
  final bool defaultValue;

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

  @override
  void reset() {
    state = defaultValue;
    save();
  }
}

class SettingIntNotifier extends Setting<int> {
  final String key;
  final int defaultValue;
  final int min;
  final int max;

  SettingIntNotifier({
    required this.key,
    required this.defaultValue,
    required this.max,
    this.min = 0,
  });

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

  @override
  void reset() {
    state = defaultValue;
    save();
  }
}

class SettingDoubleNotifier extends Setting<double> {
  final String key;
  final double defaultValue;
  final double min;
  final double max;

  SettingDoubleNotifier(
      {required this.key,
      required this.defaultValue,
      this.min = 0,
      required this.max});

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

  @override
  void reset() {
    state = defaultValue;
    save();
  }
}

class SettingStringNotifier extends Setting<String> {
  final String key;
  final String defaultValue;

  SettingStringNotifier({
    required this.key,
    required this.defaultValue,
  });

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

  @override
  void reset() {
    state = defaultValue;
    save();
  }
}

typedef FromName<T> = T? Function(String);

class SettingEnumNotifier<T extends Enum> extends Setting<T> {
  final FromName<T> fromName;
  final String key;
  final T defaultValue;

  SettingEnumNotifier({
    required this.fromName,
    required this.key,
    required this.defaultValue,
  });

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

  @override
  void reset() {
    state = defaultValue;
    save();
  }
}
