import 'package:beat_pads/screens/var_pads.dart';
import 'package:beat_pads/screens/pads_menu.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool inPortrait = MediaQuery.of(context).orientation.name == "portrait";

    // PORTRAIT: SHOW PADS SETTINGS MENU
    if (inPortrait) {
      return Scaffold(
        appBar: AppBar(),
        body: PadsMenu(),
      );
    }
    // LANDSCAPE: PLAY PADS
    else {
      return Scaffold(
        body: VariablePads(),
      );
    }
  }
}
