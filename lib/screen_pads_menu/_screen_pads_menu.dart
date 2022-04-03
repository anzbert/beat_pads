import 'package:flutter/material.dart';

import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/screen_pads_menu/menu.dart';

class PadMenuScreen extends StatelessWidget {
  const PadMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beat Pads"),
      ),
      drawer: Drawer(
        child: MidiConfig(),
      ),
      body: SafeArea(child: PadsMenu()),
    );
  }
}
