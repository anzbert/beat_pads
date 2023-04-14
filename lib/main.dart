import 'package:beat_pads/screen_splash/_screen_splash.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/rendering.dart'; // for debug repaint rainbow, if enabled in main()
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the shared_preferences Object, which can load and save persistent data
final sharedPrefProvider = Provider<Prefs>((ref) {
  throw UnimplementedError(); // overriden in ProviderScope
});

// MAIN FUNCTION ////////////////////////////////////////////////////////
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugRepaintRainbowEnabled = true;

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
