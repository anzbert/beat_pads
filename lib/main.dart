import 'package:beat_pads/screen_splash/_screen_splash.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart'; // for Riverpod logger (uncomment in ProviderScope() )
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/rendering.dart'; // for visual debug helpers (uncomment in main() function)
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the shared_preferences Object, which can load and save persistent data
final Provider<Prefs> sharedPrefProvider = Provider<Prefs>((ref) {
  throw UnimplementedError(); // overriden in ProviderScope
});

// TODO: BUG LIST
// - reported, but have not experienced this one myself: some root notes displayed in grey instead of in color

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
            // uncomment observers line to log Riverpod changes:
            // observers: kDebugMode ? [DebugRiverpodLogger()] : null,
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
