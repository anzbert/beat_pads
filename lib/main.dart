import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './splash_screen.dart';

Future<void> main() async {
  // finish all binding initializations:
  WidgetsFlutterBinding.ensureInitialized();

  // lock orientation:
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // hide android menubars:
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // run app:
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
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}

/////////////////////////////////////////////////
