import 'package:beat_pads/services/_services.dart';
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
    "sustainTimeStep": 0,
    "sendCC": false,
    "showNoteNames": true,
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
    "modulationDeadZone": 15,
    "modulationRadius": 11,
    "mpePitchBendRange": 48,
    "mpe1DRadius": "mpeAftertouch",
    "mpe2DX": "slide",
    "mpe2DY": "pitchbend",
    "padColors": "highlightRoot",
    "baseHue": 240,
  };
}

class LoadSettings {
  final Setting<int> modulationDeadZone;
  final Setting<int> modulationRadius;
  final Setting<bool> modulation2D;
  final Setting<int> mpeMemberChannels;
  final Setting<int> mpePitchBendRange;
  final Setting<MPEmods> mpe1DRadius;
  final Setting<int> baseHue;
  final Setting<PadColors> padColors;
  final Setting<MPEmods> mpe2DX;
  final Setting<MPEmods> mpe2DY;

  final Setting<Layout> layout;
  final Setting<PlayMode> playMode;
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
  final Setting<int> pitchBendEase;
  final Setting<bool> modWheel;
  final Setting<bool> sendCC;
  final Setting<bool> showNoteNames;
  final Setting<bool> pitchBend;
  final Setting<bool> octaveButtons;
  final Setting<bool> sustainButton;
  final Setting<bool> randomVelocity;

  LoadSettings(Map<String, dynamic> loadedMap)
      : padColors = Setting<PadColors>(
            "padColors",
            PadColors.fromName(loadedMap["padColors"]) ??
                PadColors.circleOfFifth),
        mpe2DX = Setting<MPEmods>(
            'mpe2DX', MPEmods.fromName(loadedMap['mpe2DX']) ?? MPEmods.slide),
        mpe2DY = Setting<MPEmods>('mpe2DY',
            MPEmods.fromName(loadedMap['mpe2DY']) ?? MPEmods.pitchbend),
        mpe1DRadius = Setting<MPEmods>(
            'mpe1DRadius',
            MPEmods.fromName(loadedMap['mpe1DRadius']) ??
                MPEmods.mpeAftertouch),
        layout = Setting<Layout>(
            'layout', Layout.fromName(loadedMap['layout']) ?? Layout.values[0]),
        mpePitchBendRange =
            Setting<int>('mpePitchBendRange', loadedMap['mpePitchBendRange']!),
        mpeMemberChannels =
            Setting<int>('mpeMemberChannels', loadedMap['mpeMemberChannels']!),
        modulation2D =
            Setting<bool>('modulation2D', loadedMap['modulation2D']!),
        modulationDeadZone = Setting<int>(
            "modulationDeadZone", loadedMap['modulationDeadZone']!),
        modulationRadius =
            Setting<int>("modulationRadius", loadedMap['modulationRadius']!),
        baseHue = Setting<int>("baseHue", loadedMap["baseHue"]!),
        rootNote = Setting<int>("rootnote", loadedMap['rootNote']!),
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
        pitchBend = Setting<bool>('pitchBend', loadedMap['pitchBend']!),
        pitchBendEase =
            Setting<int>('pitchBendEase', loadedMap['pitchBendEase']!),
        modWheel = Setting<bool>('modWheel', loadedMap['modWheel']!),
        octaveButtons =
            Setting<bool>('octaveButtons', loadedMap['octaveButtons']!!),
        sustainButton =
            Setting<bool>('sustainButton', loadedMap['sustainButton']!),
        randomVelocity =
            Setting<bool>('randomVelocity', loadedMap['randomVelocity']!),
        scaleString = Setting<String>(
            'scaleString',
            midiScales.containsKey(loadedMap['scaleString'])
                ? loadedMap['scaleString']
                : midiScales.keys.toList()[0]),
        playMode = Setting<PlayMode>('playMode',
            PlayMode.fromName(loadedMap['playMode']) ?? PlayMode.slide);

  factory LoadSettings.defaults() {
    return LoadSettings(Prefs._defaults);
  }
}

class Setting<T> {
  Setting(this.sharedPrefsKey, this.value);

  final String sharedPrefsKey;
  T value;

  Future<bool> save() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    bool result = true;

    if (value is Layout) {
      Layout cast = value as Layout;
      result = await sharedPrefs.setString("layout", cast.name);
    } else if (value is PadColors) {
      PadColors cast = value as PadColors;
      result = await sharedPrefs.setString("padColors", cast.name);
    } else if (value is PlayMode) {
      PlayMode cast = value as PlayMode;
      result = await sharedPrefs.setString("playMode", cast.name);
    } else if (value is MPEmods) {
      MPEmods cast = value as MPEmods;
      result = await sharedPrefs.setString("playMode", cast.name);
    } else if (value is int) {
      result = await sharedPrefs.setInt(sharedPrefsKey, value as int);
    } else if (value is String) {
      result = await sharedPrefs.setString(sharedPrefsKey, value as String);
    } else if (value is bool) {
      result = await sharedPrefs.setBool(sharedPrefsKey, value as bool);
    }

    if (!result) Utils.logd("Setting<${value.runtimeType}>.save() error");
    return result;
  }
}
