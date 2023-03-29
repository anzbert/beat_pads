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

  // void reset() {
  //   settings = LoadSettings.defaults();
  // }
}


  
        // scale = SettingEnum<Scale>(
          
        //   fromName: Scale.fromName,
        //   key: 'scaleString',
        //   defaultValue: Scale.chromatic,
        // ),
        
        velocityMode = SettingEnum<VelocityMode>(
          
          fromName: VelocityMode.fromName,
          key: 'velocityMode',
          defaultValue: VelocityMode.fixed,
        ),
        mpePitchBendRange = SettingInt(
          
          key: 'mpePitchBendRange',
        defaultValue:   48,
          min: 1,
          max: 48,
        ),
        mpeMemberChannels = SettingInt(
          
          key: 'mpeMemberChannels',
       defaultValue:    8,
          min: 1,
          max: 15,
        ),
        modulation2D = SettingBool(
          
          key: 'modulation2D',
          defaultValue: true,
        ),
        modulationDeadZone = SettingDouble(
          
          key: 'modulationDeadZone',
         defaultValue:  .20,
          min: .10,
          max: .50,
        ),
        modulationRadius = SettingDouble(
          
          key: 'modulationRadius',
         defaultValue:  .12,
          min: .05,
          max: .25,
        ),
        baseHue = SettingInt(
          
          key: "baseHue",
         defaultValue:  240,
          max: 360,
        ),
        rootNote = SettingInt(
          
          key: 'rootNote',
       defaultValue:    0,
          max: 11,
        ),
        channel = SettingInt(
          
          key: 'channel',
       defaultValue:    0,
          max: 15,
        ),
        width = SettingInt(
          
          key: 'width',
       defaultValue:    4,
          min: 2,
          max: 16,
        ),
        height = SettingInt(
          
          key: 'height',
       defaultValue:    4,
          min: 2,
          max: 16,
        ),
        baseOctave = SettingInt(
          
          key: 'baseOctave',
       defaultValue:    1,
          min: -2,
          max: 7,
        ),
        base = SettingInt(
          
          key: 'base',
       defaultValue:    0,
          max: 11,
        ),
        velocity = SettingInt(
          
          key: 'velocity',
         defaultValue:  110,
          max: 127,
        ),
        velocityMin = SettingInt(
          
          key: 'velocityMin',
         defaultValue:  100,
          max: 126,
        ),
        velocityMax = SettingInt(
          
          key: 'velocityMax',
         defaultValue:  110,
          max: 127,
        ),
        pitchBendEase = SettingInt(
          
          key: 'pitchBendEase',
       defaultValue:    0,
          max: Timing.releaseDelayTimes.length - 1,
        ),
        noteSustainTimeStep = SettingInt(
          
          key: 'noteSustainTimeStep',
       defaultValue:    0,
          max: Timing.releaseDelayTimes.length - 1,
        ),
        modSustainTimeStep = SettingInt(
          
          key: 'modSustainTimeStep',
       defaultValue:    0,
          max: Timing.releaseDelayTimes.length - 1,
        ),
        sendCC = SettingBool(
          
          key: 'sendCC',
          defaultValue: false,
        ),
        pitchBend = SettingBool(
          
          key: 'pitchBend',
          defaultValue: false,
        ),
        velocitySlider = SettingBool(
          
          key: 'velocitySlider',
          defaultValue: false,
        ),
        velocityVisual = SettingBool(
          
          key: 'velocityVisual',
          defaultValue: false,
        ),
        modWheel = SettingBool(
          
          key: 'modWheel',
          defaultValue: false,
        ),
        octaveButtons = SettingBool(
          
          key: 'octaveButtons',
          defaultValue: false,
        ),
        sustainButton = SettingBool(
          
          key: 'sustainButton',
          defaultValue: false,
        );


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

class SettingBool extends Setting<bool> {
  SettingBool({
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

class SettingInt extends Setting<int> {
  final String key;
  final int defaultValue;
  final int min;
  final int max;

  SettingInt({
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

class SettingDouble extends Setting<double> {
  final String key;
  final double defaultValue;
  final double min;
  final double max;

  SettingDouble(
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

class SettingString extends Setting<String> {
  final String key;
  final String defaultValue;

  SettingString({
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

class SettingEnum<T extends Enum> extends Setting<T> {
  final FromName<T> fromName;
  final String key;
  final T defaultValue;

  SettingEnum({
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
