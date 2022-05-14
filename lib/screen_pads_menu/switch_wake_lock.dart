import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';

class SwitchWakeLockTile extends StatefulWidget {
  const SwitchWakeLockTile({Key? key}) : super(key: key);

  @override
  State<SwitchWakeLockTile> createState() => _SwitchWakeLockTileState();
}

class _SwitchWakeLockTileState extends State<SwitchWakeLockTile> {
  bool wakeLock = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Wake Lock"),
      subtitle: const Text("Keep the Screen on when using the Pads"),
      trailing: Switch(
          value: wakeLock,
          onChanged: (value) {
            setState(() {
              wakeLock = !wakeLock;
            });
            Wakelock.toggle(enable: wakeLock);
          }),
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }
}
