import 'package:beat_pads/screen_splash/_screen_splash.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/rendering.dart'; // for visual debug helpers (uncomment in main() function)
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the shared_preferences Object, which can load and save persistent data
final Provider<Prefs> sharedPrefProvider = Provider<Prefs>((ref) {
  throw UnimplementedError(); // overriden in ProviderScope
});

// TODO: BUGS !!!
// - no noteoffs
// - show velocity doesnt work

// MAIN FUNCTION ////////////////////////////////////////////////////////
void main() async {
  // debugPaintSizeEnabled = true;
  // debugRepaintRainbowEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();

  await DeviceUtils.hideSystemUi()
      .then((_) => DeviceUtils.enableRotation())
      .then((_) => Prefs.initAsync())
      .then(
        (initialPreferences) => runApp(
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
