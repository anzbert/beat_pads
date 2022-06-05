import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._();
  late SharedPreferences sharedPrefs;
  late Map<String, dynamic> _startUpSettings;
  late LoadSettings settings;

  static Future<Prefs> initAsync() async {
    Prefs instance = Prefs._();

    instance.sharedPrefs = await SharedPreferences.getInstance();

    instance._startUpSettings = Prefs.defaults.map((key, _) {
      var loadedVal = instance.sharedPrefs.get(key);
      return MapEntry(key, loadedVal);
    });

    instance.settings = LoadSettings(instance._startUpSettings);
    return instance;
  }

  void reset() {
    settings = LoadSettings(null);
  }

  // currently not using these default values:
  static const Map<String, dynamic> defaults = {
    "layout": "majorThird",
    "playMode": "slide",
    "rootNote": 0,
    "width": 4,
    "height": 4,
    "baseOctave": 1,
    "base": 0,
    "velocity": 110,
    "velocityMin": 110,
    "velocityMax": 120,
    "noteSustainTimeStep": 0,
    "modSustainTimeStep": 0,
    "sendCC": false,
    "velocitySlider": false,
    "pitchBend": false,
    "octaveButtons": false,
    "sustainButton": false,
    "randomVelocity": false,
    "scaleString": "chromatic",
    "channel": 2,
    "pitchBendEase": 0,
    "modWheel": false,
    "mpeMemberChannels": 8,
    "modulation2D": true,
    "modulationRadius": 11,
    "modulationDeadZone": 20,
    "mpePitchBendRange": 48,
    "mpe1DRadius": "mpeAftertouch",
    "mpe2DX": "slide",
    "mpe2DY": "pitchbend",
    "padLabels": "note",
    "padColors": "highlightRoot",
    "baseHue": 240,
  };
}

class LoadSettings {
  final SettingEnum<PadColors> padColors;
  final SettingEnum<PadLabels> padLabels;
  final SettingEnum<Layout> layout;
  final SettingEnum<PlayMode> playMode;
  final SettingEnum<MPEmods> mpe1DRadius;
  final SettingEnum<MPEmods> mpe2DX;
  final SettingEnum<MPEmods> mpe2DY;
  final SettingString scaleString;
  final SettingDouble modulationDeadZone;
  final SettingDouble modulationRadius;
  final SettingInt mpeMemberChannels;
  final SettingInt mpePitchBendRange;
  final SettingInt baseHue;
  final SettingInt channel;
  final SettingInt rootNote;
  final SettingInt width;
  final SettingInt height;
  final SettingInt baseOctave;
  final SettingInt base;
  final SettingInt velocity;
  final SettingInt velocityMin;
  final SettingInt velocityMax;
  final SettingInt noteSustainTimeStep;
  final SettingInt modSustainTimeStep;
  final SettingInt pitchBendEase;
  final SettingBool modulation2D;
  final SettingBool modWheel;
  final SettingBool sendCC;
  final SettingBool pitchBend;
  final SettingBool octaveButtons;
  final SettingBool sustainButton;
  final SettingBool randomVelocity;
  final SettingBool velocitySlider;

  LoadSettings(Map<String, dynamic>? loadedMap)
      : padLabels = SettingEnum<PadLabels>(
          loadedMap,
          PadLabels.fromName,
          "padLabels",
          PadLabels.note,
        ),
        padColors = SettingEnum<PadColors>(
          loadedMap,
          PadColors.fromName,
          "padColors",
          PadColors.highlightRoot,
        ),
        mpe2DX = SettingEnum<MPEmods>(
          loadedMap,
          MPEmods.fromName,
          'mpe2DX',
          MPEmods.slide,
        ),
        mpe2DY = SettingEnum<MPEmods>(
          loadedMap,
          MPEmods.fromName,
          'mpe2DY',
          MPEmods.pitchbend,
        ),
        mpe1DRadius = SettingEnum<MPEmods>(
          loadedMap,
          MPEmods.fromName,
          'mpe1DRadius',
          MPEmods.mpeAftertouch,
        ),
        layout = SettingEnum<Layout>(
          loadedMap,
          Layout.fromName,
          'layout',
          Layout.majorThird,
        ),
        playMode = SettingEnum<PlayMode>(
          loadedMap,
          PlayMode.fromName,
          'playMode',
          PlayMode.slide,
        ),
        mpePitchBendRange = SettingInt(
          loadedMap,
          'mpePitchBendRange',
          48,
          min: 1,
          max: 48,
        ),
        mpeMemberChannels = SettingInt(
          loadedMap,
          'mpeMemberChannels',
          8,
          min: 1,
          max: 15,
        ),
        modulation2D = SettingBool(
          loadedMap,
          'modulation2D',
          true,
        ),
        modulationDeadZone = SettingDouble(
          loadedMap,
          'modulationDeadZone',
          20,
          min: 10,
          max: 40,
        ),
        modulationRadius = SettingDouble(
          loadedMap,
          'modulationRadius',
          11,
          min: 5,
          max: 25,
        ),
        baseHue = SettingInt(
          loadedMap,
          "baseHue",
          240,
          max: 360,
        ),
        rootNote = SettingInt(
          loadedMap,
          'rootNote',
          0,
          max: 11,
        ),
        channel = SettingInt(
          loadedMap,
          'channel',
          0,
          max: 15,
        ),
        width = SettingInt(
          loadedMap,
          'width',
          4,
          min: 2,
          max: 16,
        ),
        height = SettingInt(
          loadedMap,
          'height',
          4,
          min: 2,
          max: 16,
        ),
        baseOctave = SettingInt(
          loadedMap,
          'baseOctave',
          1,
          min: -2,
          max: 7,
        ),
        base = SettingInt(
          loadedMap,
          'base',
          0,
          max: 11,
        ),
        velocity = SettingInt(
          loadedMap,
          'velocity',
          110,
          max: 127,
        ),
        velocityMin = SettingInt(
          loadedMap,
          'velocityMin',
          100,
          max: 126,
        ),
        velocityMax = SettingInt(
          loadedMap,
          'velocityMax',
          110,
          max: 127,
        ),
        pitchBendEase = SettingInt(
          loadedMap,
          'pitchBendEase',
          0,
          max: Timing.timingSteps.length - 1,
        ),
        noteSustainTimeStep = SettingInt(
          loadedMap,
          'noteSustainTimeStep',
          0,
          max: Timing.timingSteps.length - 1,
        ),
        modSustainTimeStep = SettingInt(
          loadedMap,
          'modSustainTimeStep',
          0,
          max: Timing.timingSteps.length - 1,
        ),
        sendCC = SettingBool(
          loadedMap,
          'sendCC',
          false,
        ),
        pitchBend = SettingBool(
          loadedMap,
          'pitchBend',
          false,
        ),
        velocitySlider = SettingBool(
          loadedMap,
          'velocitySlider',
          false,
        ),
        modWheel = SettingBool(
          loadedMap,
          'modWheel',
          false,
        ),
        octaveButtons = SettingBool(
          loadedMap,
          'octaveButtons',
          false,
        ),
        sustainButton = SettingBool(
          loadedMap,
          'sustainButton',
          false,
        ),
        randomVelocity = SettingBool(
          loadedMap,
          'randomVelocity',
          false,
        ),
        scaleString = SettingString(
          loadedMap,
          'scaleString',
          "chromatic",
        );
}

abstract class Setting<T> extends StateNotifier<T> {
  final String sharedPrefsKey;
  final T defaultValue;

  Setting(this.sharedPrefsKey, T? value, this.defaultValue)
      : super(value ?? defaultValue) {
    if (value == null && state == defaultValue) save();
  }

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

class SettingBool extends Setting<bool> {
  SettingBool(Map<String, dynamic>? map, String key, bool defaultValue)
      : super(key, map?[key], defaultValue);

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setBool(sharedPrefsKey, state);
  }

  void toggle() {
    state = !state;
  }
}

class SettingInt extends Setting<int> {
  final int min;
  final int max;

  SettingInt(Map<String, dynamic>? map, String key, int defaultValue,
      {this.min = 0, required this.max})
      : super(
          key,
          map?[key],
          defaultValue,
        );

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setInt(sharedPrefsKey, state);
  }

  void increment() => set(state + 1);
  void decrement() => set(state - 1);

  @override
  void set(int newState) {
    state = newState.clamp(min, max);
  }
}

class SettingDouble extends Setting<double> {
  final double min;
  final double max;

  SettingDouble(Map<String, dynamic>? map, String key, double defaultValue,
      {this.min = 0, required this.max})
      : super(
          key,
          map?[key] / 100,
          defaultValue / 100,
        );

  @override
  void set(double newState) {
    state = newState.clamp(min, max);
  }

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setInt(sharedPrefsKey, (state * 100).toInt());
  }
}

class SettingString extends Setting<String> {
  SettingString(Map<String, dynamic>? map, String key, String defaultValue)
      : super(
          key,
          map?[key],
          defaultValue,
        );

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setString(sharedPrefsKey, state);
  }
}

typedef FromName<T> = T? Function(String);

class SettingEnum<T extends Enum> extends Setting<T> {
  SettingEnum(Map<String, dynamic>? map, FromName<T> fromName, String key,
      T defaultValue)
      : super(
          key,
          fromName(map?[key] ?? ""),
          defaultValue,
        );

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setString(sharedPrefsKey, state.name);
  }
}
