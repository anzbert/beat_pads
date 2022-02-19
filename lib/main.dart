import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import './soundboard.dart';
import './midilist.dart';
import './services/utils.dart';

// void main() {
//   runApp(App());
// }

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
  final MidiCommand _midi = MidiCommand();

  MidiDevice? currentDevice;

  void setDevice(MidiDevice device) {
    log("...connecting to : ${device.name}");

    _midi.connectToDevice(device).then((_) => setState(() {
          currentDevice = device;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: currentDevice != null
            ? MidiList(_midi, setDevice)
            : SoundBoard(lowestNote: 36),
      ),
    );
  }

  @override
  void dispose() {
    _midi.dispose();
    super.dispose();
  }
}
