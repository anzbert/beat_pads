import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/services/services.dart';

class DropdownPlayMode extends StatelessWidget {
  DropdownPlayMode({Key? key}) : super(key: key);

  final items = PlayMode.values
      .map(
        (mode) => DropdownMenuItem(
          value: mode,
          child: Text(mode.title),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<PlayMode>(
        value: Provider.of<Settings>(context, listen: true).playMode,
        items: items,
        onChanged: (value) {
          if (value != null) {
            Provider.of<Settings>(context, listen: false).playMode = value;
          }
        },
      ),
    );
  }
}
