import 'package:beat_pads/screen_pads_menu/box_credits.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/services/_services.dart';

import 'package:beat_pads/screen_pads_menu/switch_wake_lock.dart';

class MenuSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return ListView(
        children: <Widget>[
          ListTile(
            title: Divider(),
            trailing: Text(
              "System Settings",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize),
            ),
          ),
          SwitchWakeLockTile(),
          ListTile(
            title: ElevatedButton(
              child: Text(
                "Connect Midi (${settings.connectedDevices} connected)",
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              style: ElevatedButton.styleFrom(
                  primary: Palette.laserLemon.color,
                  textStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          ListTile(
            title: SnackMessageButton(
              label: "Reset Midi Buffers",
              message: "Received Midi Buffer cleared",
              onPressed: () {
                Provider.of<MidiReceiver>(context, listen: false)
                    .resetRxBuffer();
                MidiUtils.sendAllNotesOffMessage(settings.channel);
              },
            ),
          ),
          ListTile(
            title: ElevatedButton(
              child: Text(
                "Reset All Settings",
              ),
              style: ElevatedButton.styleFrom(
                primary: Palette.lightPink.color,
              ),
              onPressed: () {
                Function resetAllSettings =
                    Provider.of<Settings>(context, listen: false).resetAll;
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
          CreditsBox(),
        ],
      );
    });
  }
}
