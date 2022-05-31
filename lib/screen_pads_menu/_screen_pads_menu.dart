import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/menu_input.dart';
import 'package:beat_pads/screen_pads_menu/menu_layout.dart';
import 'package:beat_pads/screen_pads_menu/menu_midi.dart';
import 'package:beat_pads/screen_pads_menu/menu_system.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/shared_components/_shared.dart';
import 'package:provider/provider.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:beat_pads/services/services.dart';

enum Menu {
  layout,
  midi,
  input,
  system;
}

class PadMenuScreen extends StatelessWidget {
  const PadMenuScreen();
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
                      Navigator.push(
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
              backgroundColor: Palette.lightGrey,
              currentIndex: context.watch<Settings>().selectedMenu.index,
              onTap: (int tappedIndex) {
                context.read<Settings>().selectedMenu =
                    Menu.values[tappedIndex];
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
              child: Consumer<Settings>(
                builder: (context, settings, _) {
                  if (settings.selectedMenu == Menu.input) return MenuInput();
                  if (settings.selectedMenu == Menu.midi) return MenuMidi();
                  if (settings.selectedMenu == Menu.system) return MenuSystem();
                  return MenuLayout();
                },
              ),
            ),
          );
        } else {
          return const SizedBox.expand();
        }
      },
    );
  }
}
