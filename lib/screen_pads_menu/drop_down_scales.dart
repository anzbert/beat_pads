import 'package:beat_pads/main.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownScales extends ConsumerWidget {
  DropdownScales({Key? key}) : super(key: key);

  final items = midiScales.keys
      .toList()
      .map((String entry) => DropdownMenuItem<String>(
            value: entry,
            child: Text(entry),
          ))
      .toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        value: ref.watch(settingsProvider.select((value) => value.scaleString)),
        items: items,
        onChanged: (value) {
          if (value != null) {
            ref.read(settingsProvider).scaleString = value;
          }
        },
      ),
    );
  }
}
