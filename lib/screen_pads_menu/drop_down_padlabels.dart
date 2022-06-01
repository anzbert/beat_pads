import 'package:beat_pads/main.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownPadLabels extends ConsumerWidget {
  DropdownPadLabels({Key? key}) : super(key: key);

  final items = PadLabels.values
      .map(
        (layout) => DropdownMenuItem(
          value: layout,
          child: Text(layout.title),
        ),
      )
      .toList();

//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<PadLabels>(
        value: ref.watch(settingsProvider.select((value) => value.padLabels)),
        items: items,
        onChanged: (value) {
          if (value != null) {
            ref.read(settingsProvider).padLabels = value;
          }
        },
      ),
    );
  }
}
