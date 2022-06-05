import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/screen_splash/_screen_splash.dart';

// GLOBAL PROVIDERS /////////////////////////////////////////////////////
final sharedPrefProvider = Provider<Prefs>((ref) {
  throw UnimplementedError(); // overriden in ProviderScope
});

final settingsProvider = ChangeNotifierProvider<Settings>((ref) {
  return Settings(ref.watch(sharedPrefProvider));
});

final rxMidiStream = StreamProvider<MidiMessagePacket>(((ref) async* {
  Stream<MidiPacket> rxStream =
      MidiCommand().onMidiDataReceived ?? const Stream.empty();

  int channel = ref.watch(settingsProvider.select((value) => value.channel));

  await for (MidiPacket packet in rxStream) {
    int statusByte = packet.data[0];

    if (statusByte & 0xF0 == 0xF0) continue; // filter: no command messages
    if (statusByte & 0x0F != channel) continue; // filter: only current channel

    MidiMessageType type = MidiMessageType.fromStatusByte(statusByte);

    yield MidiMessagePacket(type, packet.data.skip(1).toList());
  }
}));

// MAIN FUNCTION ////////////////////////////////////////////////////////
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debugRepaintRainbowEnabled = true; // for debugging

  DeviceUtils.hideSystemUi()
      .then((_) => DeviceUtils.enableRotation())
      .then((_) => Prefs.initAsync())
      .then(
        (Prefs initialPreferences) => runApp(
          ProviderScope(
            overrides: [
              sharedPrefProvider.overrideWithValue(initialPreferences),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: appTheme,
              home: const SplashScreen(),
            ),
          ),
        ),
      );
}
