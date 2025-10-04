import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/screen_splash/_screen_splash.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
// ignore: unused_import
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
// import 'package:flutter/rendering.dart'; // for debug repaint rainbow, if enabled in main()
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

// SHARED PREFERENCES PROVIDER //////////////////////////////////////////
final sharedPrefProvider = Provider<Prefs>((ref) {
  throw UnimplementedError(); // overriden in ProviderScope
});

// MAIN FUNCTION ////////////////////////////////////////////////////////
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveNative.init(); // Call init before using Rive in the app

  await DeviceUtils.enableRotation();
  await DeviceUtils.hideSystemUi();

  // debugRepaintRainbowEnabled = true;

  Prefs.initAsync().then(
    (Prefs initialPreferences) => runApp(
      ProviderScope(
        // uncomment observers line to log Riverpod changes:
        // observers: kDebugMode ? [DebugRiverpodLogger()] : null,
        overrides: [sharedPrefProvider.overrideWithValue(initialPreferences)],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: const StartUp(),
        ),
      ),
    ),
  );
}

class StartUp extends ConsumerWidget {
  const StartUp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Don't `watch` state for change. Only `read` value on startup.
    return ref.read(splashScreenProv) ? const SplashScreen() : PadMenuScreen();
  }
}
