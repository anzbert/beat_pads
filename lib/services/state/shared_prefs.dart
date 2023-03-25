import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._();
  late SharedPreferences sharedPrefs;
  late LoadSettings settings;

  static Future<Prefs> initAsync() async {
    Prefs instance = Prefs._();
    instance.sharedPrefs = await SharedPreferences.getInstance();
    instance.settings = LoadSettings(instance.sharedPrefs);
    return instance;
  }

  /// make sure to refresh provider, containign prefs after resetting
  void reset() {
    settings = LoadSettings.defaults();
  }
}

class LoadSettings {
  final SettingEnum<PadColors> padColors;
  final SettingEnum<PadLabels> padLabels;
  final SettingEnum<Layout> layout;
  final SettingEnum<PlayMode> playMode;
  final SettingEnum<VelocityMode> velocityMode;
  final SettingEnum<MPEmods> mpe1DRadius;
  final SettingEnum<MPEmods> mpe2DX;
  final SettingEnum<MPEmods> mpe2DY;
  final SettingEnum<Scale> scale;
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
  final SettingBool velocitySlider;

  factory LoadSettings.defaults() {
    return LoadSettings(null);
  }

  LoadSettings(SharedPreferences? sharedprefs)
      : padLabels = SettingEnum<PadLabels>(
          sharedprefs,
          PadLabels.fromName,
          "padLabels",
          PadLabels.note,
        ),
        scale = SettingEnum<Scale>(
          sharedprefs,
          Scale.fromName,
          'scaleString',
          Scale.chromatic,
        ),
        padColors = SettingEnum<PadColors>(
          sharedprefs,
          PadColors.fromName,
          "padColors",
          PadColors.highlightRoot,
        ),
        mpe2DX = SettingEnum<MPEmods>(
          sharedprefs,
          MPEmods.fromName,
          'mpe2DX',
          MPEmods.slide,
        ),
        mpe2DY = SettingEnum<MPEmods>(
          sharedprefs,
          MPEmods.fromName,
          'mpe2DY',
          MPEmods.pitchbend,
        ),
        mpe1DRadius = SettingEnum<MPEmods>(
          sharedprefs,
          MPEmods.fromName,
          'mpe1DRadius',
          MPEmods.mpeAftertouch,
        ),
        layout = SettingEnum<Layout>(
          sharedprefs,
          Layout.fromName,
          'layout',
          Layout.majorThird,
        ),
        playMode = SettingEnum<PlayMode>(
          sharedprefs,
          PlayMode.fromName,
          'playMode',
          PlayMode.slide,
        ),
        velocityMode = SettingEnum<VelocityMode>(
          sharedprefs,
          VelocityMode.fromName,
          'velocityMode',
          VelocityMode.fixed,
        ),
        mpePitchBendRange = SettingInt(
          sharedprefs,
          'mpePitchBendRange',
          48,
          min: 1,
          max: 48,
        ),
        mpeMemberChannels = SettingInt(
          sharedprefs,
          'mpeMemberChannels',
          8,
          min: 1,
          max: 15,
        ),
        modulation2D = SettingBool(
          sharedprefs,
          'modulation2D',
          true,
        ),
        modulationDeadZone = SettingDouble(
          sharedprefs,
          'modulationDeadZone',
          .20,
          min: .10,
          max: .50,
        ),
        modulationRadius = SettingDouble(
          sharedprefs,
          'modulationRadius',
          .12,
          min: .05,
          max: .25,
        ),
        baseHue = SettingInt(
          sharedprefs,
          "baseHue",
          240,
          max: 360,
        ),
        rootNote = SettingInt(
          sharedprefs,
          'rootNote',
          0,
          max: 11,
        ),
        channel = SettingInt(
          sharedprefs,
          'channel',
          0,
          max: 15,
        ),
        width = SettingInt(
          sharedprefs,
          'width',
          4,
          min: 2,
          max: 16,
        ),
        height = SettingInt(
          sharedprefs,
          'height',
          4,
          min: 2,
          max: 16,
        ),
        baseOctave = SettingInt(
          sharedprefs,
          'baseOctave',
          1,
          min: -2,
          max: 7,
        ),
        base = SettingInt(
          sharedprefs,
          'base',
          0,
          max: 11,
        ),
        velocity = SettingInt(
          sharedprefs,
          'velocity',
          110,
          max: 127,
        ),
        velocityMin = SettingInt(
          sharedprefs,
          'velocityMin',
          100,
          max: 126,
        ),
        velocityMax = SettingInt(
          sharedprefs,
          'velocityMax',
          110,
          max: 127,
        ),
        pitchBendEase = SettingInt(
          sharedprefs,
          'pitchBendEase',
          0,
          max: Timing.releaseDelayTimes.length - 1,
        ),
        noteSustainTimeStep = SettingInt(
          sharedprefs,
          'noteSustainTimeStep',
          0,
          max: Timing.releaseDelayTimes.length - 1,
        ),
        modSustainTimeStep = SettingInt(
          sharedprefs,
          'modSustainTimeStep',
          0,
          max: Timing.releaseDelayTimes.length - 1,
        ),
        sendCC = SettingBool(
          sharedprefs,
          'sendCC',
          false,
        ),
        pitchBend = SettingBool(
          sharedprefs,
          'pitchBend',
          false,
        ),
        velocitySlider = SettingBool(
          sharedprefs,
          'velocitySlider',
          false,
        ),
        modWheel = SettingBool(
          sharedprefs,
          'modWheel',
          false,
        ),
        octaveButtons = SettingBool(
          sharedprefs,
          'octaveButtons',
          false,
        ),
        sustainButton = SettingBool(
          sharedprefs,
          'sustainButton',
          false,
        );
}

abstract class Setting<T> extends StateNotifier<T> {
  final String sharedPrefsKey;
  final T defaultValue;

  Setting(
    this.sharedPrefsKey,
    T? value,
    this.defaultValue,
  ) : super(value ?? defaultValue) {
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
  SettingBool(
    SharedPreferences? sharedPreferences,
    String key,
    bool defaultValue,
  ) : super(key, sharedPreferences?.getBool(key), defaultValue);

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

  SettingInt(SharedPreferences? sharedPreferences, String key, int defaultValue,
      {this.min = 0, required this.max})
      : super(
          key,
          sharedPreferences?.getInt(key),
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

  SettingDouble(
      SharedPreferences? sharedPreferences, String key, double defaultValue,
      {this.min = 0, required this.max})
      : super(
          key,
          sharedPreferences?.getInt(key) == null
              ? null
              : sharedPreferences!.getInt(key) == null
                  ? null
                  : sharedPreferences.getInt(key)! / 100,
          defaultValue,
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
  SettingString(
      SharedPreferences? sharedPreferences, String key, String defaultValue)
      : super(
          key,
          sharedPreferences?.getString(key),
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
  SettingEnum(SharedPreferences? sharedPreferences, FromName<T> fromName,
      String key, T defaultValue)
      : super(
          key,
          fromName(sharedPreferences?.getString(key) ?? ""),
          defaultValue,
        );

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setString(sharedPrefsKey, state.name);
  }
}
