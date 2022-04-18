import 'package:beat_pads/screen_home/model_settings.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/screen_pads_menu/menu.dart';
import 'package:provider/provider.dart';
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
              Icons.settings,
              color: Palette.yellowGreen.color,
              size: 36,
            ),
          );
        }),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Palette.yellowGreen.color,
              size: 36,
            ),
            onPressed: () {
              Function resetAllSettings =
                  Provider.of<Settings>(context, listen: false).resetAll;
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Reset'),
                  content: const Text(
                      'Return all Settings to their default values?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                        resetAllSettings();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: MidiConfig(),
      ),
      body: SafeArea(child: PadsMenu()),
    );
  }
}
