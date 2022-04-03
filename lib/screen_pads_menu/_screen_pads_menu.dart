import 'package:flutter/material.dart';

import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/screen_pads_menu/menu.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class PadMenuScreen extends StatelessWidget {
  const PadMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          'Beat Pads',
          style: Theme.of(context).textTheme.headline4,
          colors: [
            Palette.cadetBlue.color,
            Palette.lightPink.color,
            Palette.yellowGreen.color,
          ],
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu_rounded,
              color: Palette.lightGrey.color,
              size: 36,
            ),
          );
        }),
      ),
      drawer: Drawer(
        child: MidiConfig(),
      ),
      body: SafeArea(child: PadsMenu()),
    );
  }
}
