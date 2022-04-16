import 'package:beat_pads/services/_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._();
  late SharedPreferences _sharedPrefs;
  late Map<String, dynamic> _startUpSettings;
  late LoadSettings loadSettings;

  static Future<Prefs> initAsync() async {
    Prefs instance = Prefs._();

    // late inits:
    instance._sharedPrefs = await SharedPreferences.getInstance();

    instance._startUpSettings = Prefs._defaults.map((key, value) {
      var loadedVal = instance._sharedPrefs.get(key) ?? value;
      // var loadedVal = value; // debug: set to default
      return MapEntry(key, loadedVal);
    });

    // print(instance._startUpSettings.toString());
    instance.loadSettings = LoadSettings(instance._startUpSettings);

    return instance;
  }

  void refreshStore() async {
    try {
      _sharedPrefs = await SharedPreferences.getInstance();
    } catch (e) {
      throw Exception(e);
    }
  }

// DEFAULT VALUES:
  static const Map<String, dynamic> _defaults = {
    "layout": "continuous",
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
    "lockScreenButton": false,
    "randomVelocity": false,
    "scale": "chromatic",
  };

  Future<bool> saveSetting(String key, dynamic value) async {
    if (_defaults[key] is int && value is int) {
      return _sharedPrefs.setInt(key, value);
    } else if (_defaults[key] is String && value is String) {
      return _sharedPrefs.setString(key, value);
    } else if (_defaults[key] is bool && value is bool) {
      return _sharedPrefs.setBool(key, value);
    }
    return false;
  }
}

// TODO: save with setter?

class LoadSettings {
  final Layout layout;
  final String scale;
  final int rootNote;
  final int width;
  final int height;
  final int baseOctave;
  final int base;
  final int velocity;
  final int velocityMin;
  final int velocityMax;
  final int sustainTimeStep;
  final bool sendCC;
  final bool showNoteNames;
  final bool pitchBend;
  final bool octaveButtons;
  final bool lockScreenButton;
  final bool randomVelocity;

  LoadSettings(Map<String, dynamic> loadedMap)
      : scale = loadedMap['scale'],
        rootNote = loadedMap['rootNote'],
        width = loadedMap['width'],
        height = loadedMap['height'],
        baseOctave = loadedMap['baseOctave'],
        base = loadedMap['base'],
        velocity = loadedMap['velocity'],
        velocityMin = loadedMap['velocityMin'],
        velocityMax = loadedMap['velocityMax'],
        sustainTimeStep = loadedMap['sustainTimeStep'],
        sendCC = loadedMap['sendCC'],
        showNoteNames = loadedMap['showNoteNames'],
        pitchBend = loadedMap['pitchBend'],
        octaveButtons = loadedMap['octaveButtons'],
        lockScreenButton = loadedMap['lockScreenButton'],
        randomVelocity = loadedMap['randomVelocity'],
        layout =
            LayoutUtils.fromString(loadedMap['layout']) ?? Layout.values[0];

  factory LoadSettings.defaults() {
    return LoadSettings(Prefs._defaults);
  }
}

class Setting<T> {
  Setting(
    this.sharedPrefs,
    this.key,
  );
  SharedPreferences sharedPrefs;
  final String key;

  Future<bool> save(T value) async {
    if (value is int) {
      return sharedPrefs.setInt(key, value);
    } else if (value is String) {
      return sharedPrefs.setString(key, value);
    } else if (value is bool) {
      return sharedPrefs.setBool(key, value);
    } else if (value is Layout) {
      return sharedPrefs.setString(key, value.name);
    }

    return false;
  }

  T? load() {
    if (T is int || T is String || T is bool) {
      return sharedPrefs.get(key) as T;
    } else if (T is Layout) {
      return LayoutUtils.fromString(key) as T ?? Layout.values[0] as T;
    }
    return null;
  }
}
