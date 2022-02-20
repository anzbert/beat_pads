import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'package:provider/provider.dart';

import './soundboard.dart';
import './midilist.dart';
import './services/utils.dart';
import './settings.dart';

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
  final MidiCommand _midiCommand = MidiCommand();

  MidiDevice? currentDevice;

  void setDevice(MidiDevice device) {
    log("...connecting to : ${device.name}");

    _midiCommand.connectToDevice(device).then((_) => setState(() {
          currentDevice = device;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        create: (context) => Settings(),
        child: currentDevice == null
            ? MidiList(_midiCommand, setDevice)
            : SoundBoard(lowestNote: 36),
      ),
    );
  }

  @override
  void dispose() {
    _midiCommand.dispose();
    super.dispose();
  }
}
