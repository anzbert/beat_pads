import 'package:beat_pads/main.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownLayout extends ConsumerWidget {
  DropdownLayout({Key? key}) : super(key: key);

  final items = Layout.values
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
      child: DropdownButton<Layout>(
        value: ref.watch(settingsProvider.select((value) => value.layout)),
        items: items,
        onChanged: (value) {
          if (value != null) {
            ref.read(settingsProvider).layout = value;
          }
        },
      ),
    );
  }
}
