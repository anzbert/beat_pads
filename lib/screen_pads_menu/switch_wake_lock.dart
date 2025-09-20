import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_riverpod/legacy.dart';

final _wakeLockProv = StateProvider<bool>((ref) => false);

class SwitchWakeLockTile extends ConsumerWidget {
  const SwitchWakeLockTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Wake Lock'),
      subtitle: const Text('Keep the screen locked on'),
      trailing: Switch(
        value: ref.watch(_wakeLockProv),
        onChanged: (v) {
          ref.read(_wakeLockProv.notifier).state = v;
          WakelockPlus.toggle(enable: v);
        },
      ),
    );
  }
}
