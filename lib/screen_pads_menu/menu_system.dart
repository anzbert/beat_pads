import 'package:beat_pads/main.dart';
import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_pads_menu/box_credits.dart';
import 'package:beat_pads/services/services.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'package:beat_pads/shared_components/_shared.dart';

import 'package:beat_pads/screen_pads_menu/switch_wake_lock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuSystem extends ConsumerWidget {
  final double buttonMinWidth = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Divider(),
          trailing: Text(
            "System Settings",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline5!.fontSize),
          ),
        ),
        const SwitchWakeLockTile(),
        const Divider(),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: buttonMinWidth),
            child: ElevatedButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              style: ElevatedButton.styleFrom(
                  primary: Palette.lightPink,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              child: const Text(
                "Select Midi Device",
              ),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: buttonMinWidth),
            child: SnackMessageButton(
              label: "Reset Midi Buffers",
              message: "Midi Buffer cleared & Stop all Notes sent",
              onPressed: () {
                ref.read(receiverProvider.notifier).resetRxBuffer();
                MidiUtils.sendAllNotesOffMessage(settings.channel);
              },
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: buttonMinWidth),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Palette.laserLemon,
              ),
              child: const Text(
                "Reset All Settings",
              ),
              onPressed: () {
                Function resetAllSettings = settings.resetAll;
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Reset'),
                    content: const Text(
                        'Return all Settings to their default values?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          resetAllSettings();
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
        const Divider(),
        const CreditsBox(),
      ],
    );
  }
}
