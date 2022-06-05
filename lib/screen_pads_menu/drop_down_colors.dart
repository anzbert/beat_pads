import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownPadColors extends ConsumerWidget {
  DropdownPadColors({Key? key}) : super(key: key);

  final items = PadColors.values
      .map(
        (colorSystem) => DropdownMenuItem(
          value: colorSystem,
          child: Text(colorSystem.title),
        ),
      )
      .toList();

//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<PadColors>(
        value: ref.watch(padColorsProv),
        items: items,
        onChanged: (value) {
          if (value != null) {
            ref.read(padColorsProv.notifier).setAndSave(value);
          }
        },
      ),
    );
  }
}
