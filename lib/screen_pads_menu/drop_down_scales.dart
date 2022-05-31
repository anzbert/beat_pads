import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:provider/provider.dart';

class DropdownScales extends StatelessWidget {
  DropdownScales({Key? key}) : super(key: key);

  final items = midiScales.keys
      .toList()
      .map((String entry) => DropdownMenuItem<String>(
            value: entry,
            child: Text(entry),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        value: context.select((Settings settings) => settings.scaleString),
        items: items,
        onChanged: (value) {
          if (value != null) {
            Provider.of<Settings>(context, listen: false).scaleString = value;
          }
        },
      ),
    );
  }
}
