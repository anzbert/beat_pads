import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';

final _wakeLockProv = StateProvider<bool>((ref) => false);

class SwitchWakeLockTile extends ConsumerWidget {
  const SwitchWakeLockTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text("Wake Lock"),
      subtitle: const Text("Keep the Screen locked on"),
      trailing: Switch(
          value: ref.watch(_wakeLockProv),
          onChanged: (v) {
            ref.read(_wakeLockProv.notifier).state = v;
            Wakelock.toggle(enable: v);
          }),
    );
  }
}
