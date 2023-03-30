import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/screen_pads_menu/box_credits.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:beat_pads/screen_pads_menu/switch_wake_lock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared_components/divider_title.dart';

class MenuSystem extends ConsumerWidget {
  static const double buttonMinWidth = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: <Widget>[
        const DividerTitle("System"),
        const SwitchWakeLockTile(),
        const DividerTitle("Reset"),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: buttonMinWidth),
            child: SnackMessageButton(
              label: "Reset Midi Buffers",
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
            constraints: const BoxConstraints(minWidth: buttonMinWidth),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.laserLemon,
              ),
              child: const Text(
                "Reset All Settings",
              ),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Reset'),
                    content: const Text(
                        'Return all settings to their default values?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          ref.read(resetAllProv.notifier).resetAll();
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
}
