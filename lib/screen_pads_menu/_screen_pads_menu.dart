import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';
import 'package:beat_pads/screen_pads_menu/menu_advanced.dart';
import 'package:beat_pads/screen_pads_menu/menu_layout.dart';
import 'package:beat_pads/screen_pads_menu/menu_midi.dart';
import 'package:beat_pads/screen_pads_menu/menu_system.dart';
import 'package:beat_pads/screens_shared_widgets/button_presets.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

final selectedMenuState = StateProvider<Menu>((ref) => Menu.layout);

enum Menu {
  layout,
  midi,
  input,
  system;
}

class PadMenuScreen extends ConsumerWidget {
  const PadMenuScreen({super.key});

  Widget getMenu(Menu menu) {
    switch (menu) {
      case Menu.layout:
        return const MenuLayout();
      case Menu.midi:
        return const MenuMidi();
      case Menu.input:
        return const MenuInput();
      case Menu.system:
        return const MenuSystem();
    }
  }

  Future<void> goToPadsScreen(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute<BeatPadsScreen>(
        builder: (context) => const BeatPadsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureBuilder(
        future: Future.delayed(
            Duration(milliseconds: Timing.screenTransitionTime), () async {
          final result = await DeviceUtils.enableRotation();
          await Future<void>.delayed(
            Duration(milliseconds: Timing.screenTransitionTime),
          );
          return result;
        }),
        builder: (context, done) {
          if (done.data == false || done.data == null) {
            return const Scaffold(body: SizedBox.expand());
          }

          return Scaffold(
            appBar: AppBar(
              title: GradientText(
                'Midi Poly Grid',
                style: Theme.of(context).textTheme.headlineMedium,
                colors: [
                  Palette.lightPink,
                  Palette.cadetBlue,
                  Palette.laserLemon,
                ],
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.cable,
                    color: Palette.lightPink,
                    size: 36,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DropdownButton(
                    value: ref.watch(presetNotifierProvider),
                    // iconSize: 32,
                    iconSize: 0, // 0 means ArrowDown Icon is off
                    iconEnabledColor: PresetButtons
                        .backgoundColors[ref.watch(presetNotifierProvider) - 1],
                    underline: const SizedBox.shrink(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        ref.read(presetNotifierProvider.notifier).set(newValue);
                      }
                    },
                    items: [
                      for (int i = 1;
                          i <= PresetButtons.backgoundColors.length;
                          i++)
                        DropdownMenuItem(
                          value: i,
                          child: Text(
                            'P$i',
                            style: TextStyle(
                              color: PresetButtons.backgoundColors[i - 1],
                              fontSize: 31,
                            ),
                          ),
                        )
                    ],
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
              onTap: (tappedIndex) {
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
                  label: 'Layout',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.music_note,
                    color: Palette.cadetBlue,
                  ),
                  icon: const Icon(Icons.music_note),
                  label: 'Midi',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.touch_app),
                  activeIcon: Icon(
                    Icons.touch_app,
                    color: Palette.cadetBlue,
                  ),
                  label: 'Advanced',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.settings,
                    color: Palette.cadetBlue,
                  ),
                  icon: const Icon(Icons.settings),
                  label: 'System',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // clear all buffers:
                ref.read(touchBuffer.notifier).allNotesOff();
                ref.read(touchReleaseBuffer.notifier).allNotesOff();
                ref.read(noteReleaseBuffer.notifier).allNotesOff();

                await goToPadsScreen(context);
              },
              backgroundColor: PresetButtons
                  .backgoundColors[ref.watch(presetNotifierProvider) - 1],
              child: Icon(
                Icons.play_arrow,
                color: Palette.darkGrey,
                size: 36,
              ),
            ),
            body: SafeArea(
              child: getMenu(ref.watch(selectedMenuState)),
            ),
          );
        },
      );
}
