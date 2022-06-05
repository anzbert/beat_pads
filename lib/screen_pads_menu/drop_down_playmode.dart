import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownPlayMode extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<PlayMode>(
        value: ref.watch(settingsProvider.select((value) => value.playMode)),
        items: items,
        onChanged: (value) {
          if (value != null) {
            ref.read(settingsProvider).playMode = value;
          }
        },
      ),
    );
  }
}
