import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';

class SwitchWakeLock extends StatefulWidget {
  const SwitchWakeLock({Key? key}) : super(key: key);

  @override
  State<SwitchWakeLock> createState() => _SwitchWakeLockState();
}

class _SwitchWakeLockState extends State<SwitchWakeLock> {
  bool wakeLock = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Wake Lock"),
      subtitle: Text("Keep the Screen on When Using the Pads"),
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
