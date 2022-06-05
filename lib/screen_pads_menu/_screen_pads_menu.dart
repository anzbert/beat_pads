import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/menu_input.dart';
import 'package:beat_pads/screen_pads_menu/menu_layout.dart';
import 'package:beat_pads/screen_pads_menu/menu_midi.dart';
import 'package:beat_pads/screen_pads_menu/menu_system.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/shared_components/_shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:beat_pads/services/services.dart';

final selectedMenuState = StateProvider<Menu>((ref) => Menu.layout);

enum Menu {
  layout,
  midi,
  input,
  system;

  Widget get menuPage {
    switch (this) {
      case Menu.layout:
        return MenuLayout();
      case Menu.midi:
        return MenuMidi();
      case Menu.input:
        return MenuInput();
      case Menu.system:
        return MenuSystem();
    }
  }
}

class PadMenuScreen extends ConsumerStatefulWidget {
  const PadMenuScreen();

  @override
  ConsumerState<PadMenuScreen> createState() => _PadMenuScreenState();
}

class _PadMenuScreenState extends ConsumerState<PadMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: ThemeConst.transitionTime),
          () async {
        final bool result = await DeviceUtils.enableRotation();
        await Future.delayed(
          Duration(milliseconds: ThemeConst.transitionTime),
        );
        return result;
      }),
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
                        MaterialPageRoute(
                            builder: ((context) => const BeatPadsScreen())),
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
              backgroundColor: Palette.darkGrey,
              currentIndex: ref.watch(selectedMenuState).index,
              onTap: (int tappedIndex) {
                ref.read(selectedMenuState.notifier).state =
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
              child: ref.watch(selectedMenuState).menuPage,
            ),
          );
        } else {
          return const Scaffold(body: SizedBox.expand());
        }
      },
    );
  }
}
