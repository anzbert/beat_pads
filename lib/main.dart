import 'package:beat_pads/services/device_utils.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../state/settings.dart';
import 'state/midi.dart';

import 'app_theme.dart';
import 'screens/screen_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DeviceUtils.hideSystemUi();

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Settings()),
        ChangeNotifierProvider(create: (context) => MidiData()),
      ],
      child: MaterialApp(
        theme: appTheme,
        home: SplashScreen(),
      ),
    );
  }
}
