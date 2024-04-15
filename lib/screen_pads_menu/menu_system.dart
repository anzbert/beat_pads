import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/screen_pads_menu/box_credits.dart';
import 'package:beat_pads/screen_pads_menu/switch_wake_lock.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:beat_pads/shared_components/divider_title.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuSystem extends ConsumerWidget {
  const MenuSystem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.only(bottom: ThemeConst.listViewBottomPadding),
      children: <Widget>[
        const DividerTitle('System'),
        const SwitchWakeLockTile(),
        ListTile(
          title: const Text('Fader Tracks Touchable'),
          subtitle: const Text(
              'Allow Faders to be moved by touching anywhere on their track'),
          trailing: Switch(
            value: ref.watch(sliderTapAndSlideProv),
            onChanged: (bool v) =>
                ref.read(sliderTapAndSlideProv.notifier).setAndSave(v),
          ),
        ),
        const DividerTitle('Reset'),
        Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(minWidth: ThemeConst.menuButtonMinWidth),
            child: SnackMessageButton(
              label: 'Reset Midi Buffers',
              message: "Midi buffer cleared & 'Stop All Notes' sent",
              onPressed: () {
                ref.read(rxNoteProvider.notifier).reset();
                MidiUtils.sendAllNotesOffMessage(ref.read(channelUsableProv));
              },
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(minWidth: ThemeConst.menuButtonMinWidth),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.lightPink,
              ),
              child: const Text(
                'Reset All Presets',
              ),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Reset'),
                    content:
                        const Text('Return All Presets to the default values?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          ref.read(resetAllProv.notifier).resetAllPresets();
                          ref.read(selectedMenuState.notifier).state =
                              Menu.layout;
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const CreditsBox(),
        const StringInfoBox(
          header: 'Credits',
          body: [
            'I want to thank these amazing testers for their extremely helpful feedback:',
            '',
            'Samplix,  A. Samek,  tyslothrop1,  tput73,  bruques',
            '',
            'Thanks also to anyone I may have forgotten to mention!',
          ],
        ),
      ],
    );
  }
}
