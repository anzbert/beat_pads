import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';

final _wakeLockProv = StateProvider<bool>((ref) => false);

class SwitchWakeLockTile extends ConsumerWidget {
  const SwitchWakeLockTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        title: const Text('Wake Lock'),
        subtitle: const Text('Keep the screen locked on'),
        trailing: Switch(
          value: ref.watch(_wakeLockProv),
          onChanged: (v) async {
            ref.read(_wakeLockProv.notifier).state = v;
            await Wakelock.toggle(enable: v);
          },
        ),
      );
}
