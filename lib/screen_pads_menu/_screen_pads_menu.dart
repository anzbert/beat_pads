import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/menu_input.dart';
import 'package:beat_pads/screen_pads_menu/menu_layout.dart';
import 'package:beat_pads/screen_pads_menu/menu_midi.dart';
import 'package:beat_pads/screen_pads_menu/menu_system.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/shared_components/_shared.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:beat_pads/services/services.dart';

class PadMenuScreen extends StatefulWidget {
  const PadMenuScreen({Key? key}) : super(key: key);

  @override
  State<PadMenuScreen> createState() => _PadMenuScreenState();
}

enum Menu {
  layout,
  midi,
  input,
  system;
}

class _PadMenuScreenState extends State<PadMenuScreen> {
  Menu selectedMenu = Menu.layout;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DeviceUtils.enableRotation(),
      builder: (context, AsyncSnapshot<bool?> done) {
        if (done.hasData && done.data == true) {
          return Scaffold(
            appBar: AppBar(
              title: GradientText(
                'Beat Pads',
                style: Theme.of(context).textTheme.headline4,
                colors: [
                  Palette.lightPink,
                  Palette.cadetBlue,
                  Palette.laserLemon,
                ],
              ),
              leading: Builder(builder: (BuildContext context) {
                return IconButton(
                  color: Palette.cadetBlue,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Palette.lightPink,
                    size: 36,
                  ),
                );
              }),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.play_circle_fill_rounded,
                      color: Palette.laserLemon,
                      size: 36,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        TransitionUtils.fade(const BeatPadsScreen()),
                      );
                    },
                  ),
                )
              ],
            ),
            drawer: const Drawer(
              child: MidiConfig(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Palette.cadetBlue,
              backgroundColor: Palette.darkGrey.withOpacity(0.5),
              currentIndex: selectedMenu.index,
              onTap: (int tappedIndex) {
                setState(() => selectedMenu = Menu.values[tappedIndex]);
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.apps),
                  activeIcon: Icon(
                    Icons.apps,
                    color: Palette.cadetBlue,
                  ),
                  label: "Layout",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.music_note,
                    color: Palette.cadetBlue,
                  ),
                  icon: const Icon(Icons.music_note),
                  label: "Midi",
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.touch_app),
                  activeIcon: Icon(
                    Icons.touch_app,
                    color: Palette.cadetBlue,
                  ),
                  label: "Input",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.settings,
                    color: Palette.cadetBlue,
                  ),
                  icon: const Icon(Icons.settings),
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
        } else {
          return const Text("menu orientation error");
        }
      },
    );
  }
}
