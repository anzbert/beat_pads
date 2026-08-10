import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final _wakeLockProv = NotifierProvider<WakeLockNotifier, bool>(
  WakeLockNotifier.new,
);

class WakeLockNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setValue(bool value) => state = value;
}

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
          ref.read(_wakeLockProv.notifier).setValue(v);
          WakelockPlus.toggle(enable: v);
        },
      ),
    );
  }
}
