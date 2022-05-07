import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/menu_input.dart';
import 'package:beat_pads/screen_pads_menu/menu_layout.dart';
import 'package:beat_pads/screen_pads_menu/menu_midi.dart';
import 'package:beat_pads/screen_pads_menu/menu_system.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/shared/_shared.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:beat_pads/services/_services.dart';

class PadMenuScreen extends StatefulWidget {
  const PadMenuScreen({Key? key}) : super(key: key);

  @override
  State<PadMenuScreen> createState() => _PadMenuScreenState();
}

enum Menu {
  layout,
  input,
  midi,
  system;
}

class _PadMenuScreenState extends State<PadMenuScreen> {
  Menu selectedMenu = Menu.layout;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DeviceUtils.enableRotation(),
      builder: ((context, _) {
        return Scaffold(
          appBar: AppBar(
            title: GradientText(
              'Beat Pads',
              style: Theme.of(context).textTheme.headline4,
              colors: [
                Palette.lightPink.color,
                Palette.yellowGreen.color,
                Palette.cadetBlue.color,
              ],
            ),
            leading: Builder(builder: (BuildContext context) {
              return Row(
                children: [
                  IconButton(
                    color: Palette.cadetBlue.color,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(
                      Icons.import_export_rounded,
                      color: Palette.lightPink.color,
                      size: 36,
                    ),
                  ),
                ],
              );
            }),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    Icons.check_rounded,
                    color: Palette.cadetBlue.color,
                    size: 36,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      TransitionUtils.fade(BeatPadsScreen()),
                    );
                  },
                ),
              )
            ],
          ),
          drawer: Drawer(
            child: MidiConfig(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Palette.laserLemon.color,
            backgroundColor: Palette.darkGrey.color,
            currentIndex: selectedMenu.index,
            onTap: (int tappedIndex) {
              setState(() => selectedMenu = Menu.values[tappedIndex]);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.apps),
                activeIcon: Icon(
                  Icons.apps,
                  color: Palette.laserLemon.color,
                ),
                label: "Layout",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.touch_app),
                activeIcon: Icon(
                  Icons.touch_app,
                  color: Palette.laserLemon.color,
                ),
                label: "Input",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.music_note,
                  color: Palette.laserLemon.color,
                ),
                icon: Icon(Icons.music_note),
                label: "Midi",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.settings,
                  color: Palette.laserLemon.color,
                ),
                icon: Icon(Icons.settings),
                label: "System",
              ),
            ],
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (selectedMenu == Menu.input) return MenuInput();
                if (selectedMenu == Menu.midi) return MenuMidi();
                if (selectedMenu == Menu.system) return MenuSystem();
                return MenuLayout();
              },
            ),
          ),
        );
      }),
    );
  }
}
