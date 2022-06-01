import 'package:flutter_riverpod/flutter_riverpod.dart';

import './theme.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/screen_splash/_screen_splash.dart';

Future<void> main() async {
  // debugRepaintRainbowEnabled = true; // for debugging

  WidgetsFlutterBinding.ensureInitialized();

  DeviceUtils.hideSystemUi()
      .then((_) => DeviceUtils.enableRotation())
      .then((_) => Prefs.initAsync())
      .then((Prefs initialPreferences) => runApp(App(initialPreferences)));
}

// PROVIDERS ////////////
final sharedPrefProvider = Provider<Prefs>((ref) {
  throw UnimplementedError();
});

final settingsProvider = ChangeNotifierProvider<Settings>((ref) {
  return Settings(ref.watch(sharedPrefProvider));
});

final screenSizeState = Provider<Size>(
  (ref) => throw UnimplementedError(),
);
// //////////////////////

class App extends StatelessWidget {
  const App(this.prefs, {Key? key}) : super(key: key);

  final Prefs prefs;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        sharedPrefProvider.overrideWithValue(prefs),
        screenSizeState.overrideWithValue(MediaQuery.of(context).size),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
