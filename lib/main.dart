import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';
import './theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // hide android menubars:
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: SplashScreen(),
    );
  }
}
