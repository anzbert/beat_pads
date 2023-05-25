import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/screen_pads_menu/box_credits.dart';
import 'package:beat_pads/screen_pads_menu/switch_wake_lock.dart';
import 'package:beat_pads/screens_shared_widgets/button_snack_message.dart';
import 'package:beat_pads/screens_shared_widgets/divider_title.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuSystem extends ConsumerWidget {
  const MenuSystem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
        padding:
            const EdgeInsets.only(bottom: ThemeConst.listViewBottomPadding),
        children: <Widget>[
          const DividerTitle('System'),
          const SwitchWakeLockTile(),
          const DividerTitle('Reset'),
          Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(minWidth: ThemeConst.menuButtonMinWidth),
              child: SnackMessageButton(
                label: 'Reset Midi Buffers',
                message: "Midi buffer cleared & 'Stop All Notes' sent",
                onPressed: () {
                  // clear all buffers:
                  ref.read(touchBuffer.notifier).allNotesOff();
                  ref.read(touchReleaseBuffer.notifier).allNotesOff();
                  ref.read(noteReleaseBuffer.notifier).allNotesOff();

                  // clear received note buffer:
                  ref.read(rxNoteProvider.notifier).reset();

                  // Send all notes off:
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
                onPressed: () async {
                  await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset'),
                      content: const Text(
                        'Return All Presets to the default values?',
                      ),
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
        ],
      );
}
