import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/receiver.dart';
import '../state/settings.dart';
import 'app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide Android Menu Bar:
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Settings()),
        ChangeNotifierProvider(create: (context) => MidiReceiver()),
      ],
      child: MaterialApp(
        theme: appTheme,
        home: SplashScreen(),
      ),
    );
  }
}
