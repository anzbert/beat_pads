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
            trailing: Text(
              "System Settings",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize),
            ),
          ),
          ListTile(
            title: Text("Lock Screen Button"),
            subtitle: Text("Adds Rotation Lock Button. Long Press to Use"),
            trailing: Switch(
                value: settings.lockScreenButton,
                onChanged: (value) =>
                    settings.lockScreenButton = !settings.lockScreenButton),
          ),
          SwitchWakeLock(),
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
          CreditsBox(),
        ],
      );
    });
  }
}
