import 'package:flutter/material.dart';
import 'theme.dart';

import 'services/_services.dart';

import 'splash/_screen_splash.dart';

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
      theme: appTheme,
      home: SplashScreen(),
    );
  }
}
