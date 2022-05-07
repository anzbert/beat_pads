import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool inPortrait = MediaQuery.of(context).orientation.name == "portrait";

    return FutureBuilder(
      future: Prefs.initAsync(),
      builder: (context, AsyncSnapshot<Prefs> snapshot) {
        // PREFERENCES LOADED:
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => Settings(snapshot.data!)),
            ],
            child: PadMenuScreen(),
            // child: inPortrait
            // ? PadMenuScreen() // PORTRAIT: SHOW PADS MENU
            // : BeatPadsScreen(), // LANDSCAPE: PLAY PADS
          );
        }
        // ERROR HANDLING:
        else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                  "Error Instantiating Shared Preferences Handler:\n\n${snapshot.error}"),
            ),
          );
        }
        // PENDING:
        else {
          return Scaffold(
              body: Center(
                  child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              color: Palette.cadetBlue.color,
            ),
          )));
        }
      },
    );
  }
}
