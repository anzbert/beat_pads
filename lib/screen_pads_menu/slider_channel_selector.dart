import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/screen_home/_screen_home.dart';

class ChannelSelector extends StatelessWidget {
  const ChannelSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MidiData>(
      builder: (context, receiver, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Row(
                children: [
                  Text("Midi Channel"),
                  TextButton(
                    onPressed: () => receiver.resetChannel(),
                    child: Text("Reset"),
                  )
                ],
              ),
              trailing: Text("${receiver.channel + 1}"),
            ),
            Slider(
              min: 0,
              max: 15,
              value: receiver.channel.toDouble(),
              onChanged: (value) {
                receiver.channel = value.toInt();
              },
            ),
          ],
        );
      },
    );
  }
}
