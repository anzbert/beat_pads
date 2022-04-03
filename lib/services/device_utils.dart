import 'package:flutter/services.dart';

abstract class DeviceUtils {
  /// Lock Orientation to Portrait
  static void portraitOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Lock Orientation to Landscape
  static void landscapeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Unlock Rotation
  static void enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Hide Top and Bottom Menu Bars
  static Future<void> hideSystemUi() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  /// Show Top and Bottom Menu Bars
  static Future<void> showSystemUi() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Show Top Menu Bar only
  static Future<void> showSystemUiTop() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
  }

  /// Show Bottom Menu Bar only
  static Future<void> showSystemUiBottom() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }
}
