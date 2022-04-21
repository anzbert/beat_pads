import 'package:beat_pads/services/_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._();
  late SharedPreferences _sharedPrefs;
  late Map<String, dynamic> _startUpSettings;
  late LoadSettings settings;

  static Future<Prefs> initAsync() async {
    Prefs instance = Prefs._();

    // late inits:
    instance._sharedPrefs = await SharedPreferences.getInstance();

    instance._startUpSettings = Prefs._defaults.map((key, value) {
      var loadedVal = instance._sharedPrefs.get(key) ?? value;
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
          await _sharedPrefs.setInt(entry.key, entry.value);
          break;
        case bool:
          await _sharedPrefs.setBool(entry.key, entry.value);
          break;
        case String:
          await _sharedPrefs.setString(entry.key, entry.value);
          break;
        default:
          throw "type not recognised";
      }
    }
  }

// DEFAULT VALUES:
  static const Map<String, dynamic> _defaults = {
    "layout": "Major_Third",
    "rootNote": 0,
    "width": 4,
    "height": 4,
    "baseOctave": 1,
    "base": 0,
    "velocity": 110,
    "velocityMin": 110,
    "velocityMax": 120,
    "sustainTimeStep": 2,
    "sendCC": false,
    "showNoteNames": true,
    "pitchBend": false,
    "octaveButtons": false,
    "sustainButton": false,
    "lockScreenButton": false,
    "randomVelocity": false,
    "scaleString": "chromatic",
    "channel": 0,
  };
}

class LoadSettings {
  final Setting<Layout> layout;
  final Setting<String> scaleString;
  final Setting<int> channel;
  final Setting<int> rootNote;
  final Setting<int> width;
  final Setting<int> height;
  final Setting<int> baseOctave;
  final Setting<int> base;
  final Setting<int> velocity;
  final Setting<int> velocityMin;
  final Setting<int> velocityMax;
  final Setting<int> sustainTimeStep;
  final Setting<bool> sendCC;
  final Setting<bool> showNoteNames;
  final Setting<bool> pitchBend;
  final Setting<bool> octaveButtons;
  final Setting<bool> sustainButton;
  final Setting<bool> lockScreenButton;
  final Setting<bool> randomVelocity;

  LoadSettings(Map<String, dynamic> loadedMap)
      : rootNote = Setting<int>("rootnote", loadedMap['rootNote']!),
        channel = Setting<int>('channel', loadedMap['channel']!),
        width = Setting<int>('width', loadedMap['width']!),
        height = Setting<int>('height', loadedMap['height']!),
        baseOctave = Setting<int>('baseOctave', loadedMap['baseOctave']!),
        base = Setting<int>('base', loadedMap['base']!),
        velocity = Setting<int>('velocity', loadedMap['velocity']!),
        velocityMin = Setting<int>('velocityMin', loadedMap['velocityMin']!),
        velocityMax = Setting<int>('velocityMax', loadedMap['velocityMax']!),
        sustainTimeStep =
            Setting<int>('sustainTimeStep', loadedMap['sustainTimeStep']!),
        sendCC = Setting<bool>('sendCC', loadedMap['sendCC']!),
        showNoteNames =
            Setting<bool>('showNoteNames', loadedMap['showNoteNames']!),
        pitchBend = Setting<bool>('pichBend', loadedMap['pitchBend']!),
        octaveButtons =
            Setting<bool>('octaveButtons', loadedMap['octaveButtons']!!),
        sustainButton =
            Setting<bool>('sustainButton', loadedMap['sustainButton']!),
        lockScreenButton =
            Setting<bool>('lockScreenButton', loadedMap['lockScreenButton']!),
        randomVelocity =
            Setting<bool>('randomVelocity', loadedMap['randomVelocity']!),
        scaleString = Setting<String>(
            'scaleString',
            midiScales.containsKey(loadedMap['scaleString'])
                ? loadedMap['scaleString']
                : midiScales.keys.toList()[0]),
        layout = Setting<Layout>('layout',
            LayoutUtils.fromString(loadedMap['layout']) ?? Layout.values[0]);

  factory LoadSettings.defaults() {
    return LoadSettings(Prefs._defaults);
  }
}

class Setting<T> {
  Setting(this.sharedPrefsKey, this.value);

  final String sharedPrefsKey;
  T value;

  Future<bool> save() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();

    if (value is Layout) {
      Layout cast = value as Layout;
      return _sharedPrefs.setString("layout", cast.name);
    } else if (value is int) {
      return _sharedPrefs.setInt(sharedPrefsKey, value as int);
    } else if (value is String) {
      return _sharedPrefs.setString(sharedPrefsKey, value as String);
    } else if (value is bool) {
      return _sharedPrefs.setBool(sharedPrefsKey, value as bool);
    }

    return false;
  }
}
