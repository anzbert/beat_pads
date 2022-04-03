import 'package:beat_pads/home/home.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:provider/provider.dart';

class DropdownScales extends StatelessWidget {
  DropdownScales({Key? key}) : super(key: key);

  final items = midiScales.keys
      .toList()
      .map((String entry) => DropdownMenuItem<String>(
            child: Text(entry),
            value: entry,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        // isExpanded: true,
        value: Provider.of<Settings>(context, listen: true).scale,
        items: items,
        onChanged: (value) {
          if (value != null) {
            Provider.of<Settings>(context, listen: false).scale = value;
          }
        },
      ),
    );
  }
}
