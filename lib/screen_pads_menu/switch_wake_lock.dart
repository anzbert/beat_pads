import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class _WakeLockNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setEnabled(bool enabled) {
    state = enabled;
    WakelockPlus.toggle(enable: enabled);
  }
}

final _wakeLockProv = NotifierProvider<_WakeLockNotifier, bool>(
  _WakeLockNotifier.new,
);

class SwitchWakeLockTile extends ConsumerWidget {
  const SwitchWakeLockTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Wake Lock'),
      subtitle: const Text('Keep the screen locked on'),
      trailing: Switch(
        value: ref.watch(_wakeLockProv),
        onChanged: (value) {
          ref.read(_wakeLockProv.notifier).setEnabled(value);
        },
      ),
    );
  }
}
