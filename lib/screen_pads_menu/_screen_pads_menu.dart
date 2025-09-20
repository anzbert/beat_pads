import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_beat_pads/button_presets.dart';
import 'package:beat_pads/screen_pads_menu/menu_advanced.dart';
import 'package:beat_pads/screen_pads_menu/menu_layout.dart';
import 'package:beat_pads/screen_pads_menu/menu_midi.dart';
import 'package:beat_pads/screen_pads_menu/menu_system.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:beat_pads/shared_components/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final selectedMenuState = StateProvider<Menu>((ref) => Menu.layout);

enum Menu { layout, midi, input, system }

class PadMenuScreen extends ConsumerWidget {
  PadMenuScreen() {
    DeviceUtils.enableRotation();
  }

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

  static void goToPadsScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<BeatPadsScreen>(builder: (context) => BeatPadsScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.menuHeaders,

        centerTitle: true,
        title: GradientText(
          'Midi Poly Grid',
          style: Theme.of(context).textTheme.headlineMedium,
          gradient: LinearGradient(
            colors: [Palette.lightPink, Palette.cadetBlue, Palette.laserLemon],
          ),
        ),

        leadingWidth: 110,
        leading: Builder(
          builder: (BuildContext context) {
            return Row(
              children: [
                SizedBox(width: 2),
                IconButton(
                  onPressed: () => goToPadsScreen(context),
                  padding: EdgeInsets.all(0),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(5),
                      ),
                    ),
                    backgroundColor: PresetButtons
                        .backgoundColors[ref.watch(presetNotifierProvider) - 1],
                  ),
                  icon: Icon(
                    Icons.play_arrow,
                    color: Palette.darkGrey,
                    size: 42,
                  ),
                ),
                SizedBox(width: 1),
                IconButton(
                  padding: EdgeInsets.all(0),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(5),
                      ),
                    ),
                    backgroundColor: Palette.lightPink,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.cable, color: Palette.darkGrey, size: 32),
                ),
              ],
            );
          },
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: DropdownButton(
              value: ref.watch(presetNotifierProvider),
              // iconSize: 0,
              focusColor: Colors.transparent,

              iconEnabledColor: PresetButtons
                  .backgoundColors[ref.watch(presetNotifierProvider) - 1],
              underline: SizedBox.shrink(), // -> hides underline
              onChanged: (int? newValue) {
                if (newValue != null) {
                  ref
                      .read(presetNotifierProvider.notifier)
                      .setAndSave(newValue);
                }
              },

              items: [
                for (int i = 1; i <= PresetButtons.backgoundColors.length; i++)
                  DropdownMenuItem(
                    value: i,
                    child: Text(
                      'P$i',
                      style: TextStyle(
                        color: PresetButtons.backgoundColors[i - 1],
                        fontSize: 31,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      drawer: const Drawer(child: MidiConfig()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Palette.cadetBlue,
        backgroundColor: Palette.menuHeaders,
        currentIndex: ref.watch(selectedMenuState).index,
        onTap: (int tappedIndex) {
          ref.read(selectedMenuState.notifier).state = Menu.values[tappedIndex];
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.apps),
            activeIcon: Icon(Icons.apps, color: Palette.cadetBlue),
            label: 'Layout',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.music_note, color: Palette.cadetBlue),
            icon: const Icon(Icons.music_note),
            label: 'Midi',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.touch_app),
            activeIcon: Icon(Icons.touch_app, color: Palette.cadetBlue),
            label: 'Advanced',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.settings, color: Palette.cadetBlue),
            icon: const Icon(Icons.settings),
            label: 'System',
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => goToPadsScreen(context),
      //   backgroundColor: PresetButtons
      //       .backgoundColors[ref.watch(presetNotifierProvider) - 1],
      //   child: Icon(Icons.play_arrow, color: Palette.darkGrey, size: 36),
      // ),
      body: SafeArea(child: getMenu(ref.watch(selectedMenuState))),
    );
  }
}
