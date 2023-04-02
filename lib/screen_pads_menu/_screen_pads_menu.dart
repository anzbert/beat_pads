import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_beat_pads/button_presets.dart';
import 'package:beat_pads/screen_pads_menu/menu_input.dart';
import 'package:beat_pads/screen_pads_menu/menu_layout.dart';
import 'package:beat_pads/screen_pads_menu/menu_midi.dart';
import 'package:beat_pads/screen_pads_menu/menu_system.dart';
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
}

class PadMenuScreen extends ConsumerWidget {
  final ScrollController _layoutPageScrollController = ScrollController();

  Widget getMenu(Menu menu, ScrollController sc) {
    switch (menu) {
      case Menu.layout:
        return MenuLayout(sc);
      case Menu.midi:
        return MenuMidi();
      case Menu.input:
        return MenuInput();
      case Menu.system:
        return MenuSystem();
    }
  }

  void goToPadsScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: ((context) => const BeatPadsScreen())),
    );
  }

  void goToPresetSelection(WidgetRef ref) {
    if (ref.read(selectedMenuState) == Menu.layout) {
      _layoutPageScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
    ref.read(selectedMenuState.notifier).state = Menu.layout;
  }

  PadMenuScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.delayed(
          Duration(milliseconds: Timing.screenTransitionTime), () async {
        final bool result = await DeviceUtils.enableRotation();
        await Future.delayed(
          Duration(milliseconds: Timing.screenTransitionTime),
        );
        return result;
      }),
      builder: (context, AsyncSnapshot<bool?> done) {
        if (done.hasData && done.data == true) {
          return Scaffold(
            appBar: AppBar(
              title: GradientText(
                'Beat Pads',
                style: Theme.of(context).textTheme.headlineMedium,
                colors: [
                  Palette.lightPink,
                  Palette.cadetBlue,
                  Palette.laserLemon,
                ],
              ),
              leading: Builder(builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.cable,
                    color: Palette.lightPink,
                    size: 36,
                  ),
                );
              }),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: (() => goToPresetSelection(ref)),
                    child: Text("P${ref.watch(presetNotifierProvider)}",
                        style: TextStyle(
                            color: PresetButtons.backgoundColors[
                                ref.watch(presetNotifierProvider) - 1],
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.fontSize ??
                                16)),
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
                  label: "Advanced",
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
            floatingActionButton: FloatingActionButton(
              onPressed: (() => goToPadsScreen(context)),
              backgroundColor: PresetButtons
                  .backgoundColors[ref.watch(presetNotifierProvider) - 1],
              child: Icon(
                Icons.play_arrow,
                color: Palette.darkGrey,
                size: 36,
              ),
            ),
            body: SafeArea(
              child: getMenu(
                  ref.watch(selectedMenuState), _layoutPageScrollController),
            ),
          );
        } else {
          return const Scaffold(body: SizedBox.expand());
        }
      },
    );
  }
}
