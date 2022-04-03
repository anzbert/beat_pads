import 'package:flutter/material.dart';
import './theme.dart';

import 'package:beat_pads/services/_services.dart';

import 'package:beat_pads/screen_splash/_screen_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DeviceUtils.hideSystemUi();

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // HIDE DEBUG FLAG
      theme: appTheme,
      home: SplashScreen(),
    );
  }
}
