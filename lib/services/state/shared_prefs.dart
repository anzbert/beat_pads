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

    // late inits:
    instance.sharedPrefs = await SharedPreferences.getInstance();

    instance._startUpSettings = Prefs._defaults.map((key, value) {
      var loadedVal = instance.sharedPrefs.get(key) ?? value;
      // var loadedVal = value; // debug: set to default
      return MapEntry(key, loadedVal);
    });

    instance.settings = LoadSettings(instance._startUpSettings);

    return instance;
  }

  Future<void> resetStoredValues() async {
    for (MapEntry<String, dynamic> entry in Prefs._defaults.entries) {
      switch (entry.value.runtimeType) {
        case int:
          await sharedPrefs.setInt(entry.key, entry.value);
          break;
        case bool:
          await sharedPrefs.setBool(entry.key, entry.value);
          break;
        case String:
          await sharedPrefs.setString(entry.key, entry.value);
          break;
        default:
          throw "type not recognised";
      }
    }
  }

// DEFAULT VALUES:
  static const Map<String, dynamic> _defaults = {
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
  final SettingEnum padColors;
  final SettingEnum padLabels;
  final SettingEnum layout;
  final SettingEnum playMode;
  final SettingEnum mpe1DRadius;
  final SettingEnum mpe2DX;
  final SettingEnum mpe2DY;
  final SettingString scaleString;
  final SettingInt modulationDeadZone;
  final SettingInt modulationRadius;
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

  LoadSettings(Map<String, dynamic> loadedMap)
      : padLabels = SettingEnum("padLabels",
            PadLabels.fromName(loadedMap["padLabels"]) ?? PadLabels.note),
        padColors = SettingEnum(
            "padColors",
            PadColors.fromName(loadedMap["padColors"]) ??
                PadColors.circleOfFifth),
        mpe2DX = SettingEnum(
            'mpe2DX', MPEmods.fromName(loadedMap['mpe2DX']) ?? MPEmods.slide),
        mpe2DY = SettingEnum('mpe2DY',
            MPEmods.fromName(loadedMap['mpe2DY']) ?? MPEmods.pitchbend),
        mpe1DRadius = SettingEnum(
            'mpe1DRadius',
            MPEmods.fromName(loadedMap['mpe1DRadius']) ??
                MPEmods.mpeAftertouch),
        layout = SettingEnum(
            'layout', Layout.fromName(loadedMap['layout']) ?? Layout.values[0]),
        mpePitchBendRange =
            SettingInt('mpePitchBendRange', loadedMap['mpePitchBendRange']!),
        mpeMemberChannels =
            SettingInt('mpeMemberChannels', loadedMap['mpeMemberChannels']!),
        modulation2D = SettingBool('modulation2D', loadedMap['modulation2D']!),
        modulationDeadZone =
            SettingInt("modulationDeadZone", loadedMap['modulationDeadZone']!),
        modulationRadius =
            SettingInt("modulationRadius", loadedMap['modulationRadius']!),
        baseHue = SettingInt("baseHue", loadedMap["baseHue"]!),
        rootNote = SettingInt("rootnote", loadedMap['rootNote']!),
        channel = SettingInt('channel', loadedMap['channel']!),
        width = SettingInt('width', loadedMap['width']!),
        height = SettingInt('height', loadedMap['height']!),
        baseOctave = SettingInt('baseOctave', loadedMap['baseOctave']!),
        base = SettingInt('base', loadedMap['base']!),
        velocity = SettingInt('velocity', loadedMap['velocity']!),
        velocityMin = SettingInt('velocityMin', loadedMap['velocityMin']!),
        velocityMax = SettingInt('velocityMax', loadedMap['velocityMax']!),
        noteSustainTimeStep = SettingInt(
            'noteSustainTimeStep', loadedMap['noteSustainTimeStep']!),
        modSustainTimeStep =
            SettingInt('modSustainTimeStep', loadedMap['modSustainTimeStep']!),
        sendCC = SettingBool('sendCC', loadedMap['sendCC']!),
        pitchBend = SettingBool('pitchBend', loadedMap['pitchBend']!),
        velocitySlider =
            SettingBool('velocitySlider', loadedMap['velocitySlider']!),
        pitchBendEase =
            SettingInt('pitchBendEase', loadedMap['pitchBendEase']!),
        modWheel = SettingBool('modWheel', loadedMap['modWheel']!),
        octaveButtons =
            SettingBool('octaveButtons', loadedMap['octaveButtons']!!),
        sustainButton =
            SettingBool('sustainButton', loadedMap['sustainButton']!),
        randomVelocity =
            SettingBool('randomVelocity', loadedMap['randomVelocity']!),
        scaleString = SettingString(
            'scaleString',
            midiScales.containsKey(loadedMap['scaleString'])
                ? loadedMap['scaleString']
                : midiScales.keys.toList()[0]),
        playMode = SettingEnum('playMode',
            PlayMode.fromName(loadedMap['playMode']) ?? PlayMode.slide);

  factory LoadSettings.defaults() {
    return LoadSettings(Prefs._defaults);
  }
}

abstract class Setting<T> extends StateNotifier<T> {
  final String sharedPrefsKey;

  Setting(this.sharedPrefsKey, T value) : super(value);

  void set(T newState) {
    state = newState;
  }

  Future<bool> save();
}

class SettingBool extends Setting<bool> {
  SettingBool(String sharedPrefsKey, bool state) : super(sharedPrefsKey, state);

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
  SettingInt(String sharedPrefsKey, int state) : super(sharedPrefsKey, state);

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setInt(sharedPrefsKey, state);
  }
}

class SettingString extends Setting<String> {
  SettingString(String sharedPrefsKey, String state)
      : super(sharedPrefsKey, state);

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setString(sharedPrefsKey, state);
  }
}

class SettingEnum extends Setting<Enum> {
  SettingEnum(String sharedPrefsKey, Enum state) : super(sharedPrefsKey, state);

  @override
  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setString(sharedPrefsKey, state.name);
  }
}
