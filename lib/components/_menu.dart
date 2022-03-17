import 'package:beat_pads/components/switch_wake_lock.dart';
import 'package:beat_pads/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PadsMenuTest extends StatelessWidget {
  PadsMenuTest({Key? key}) : super(key: key) {
    baseMenuElements.add(rotateLabel());
    baseMenuElements.add(switchNoteNames());
    baseMenuElements.add(SwitchWakeLock());
  }

  final List<Widget> baseMenuElements = [];

  @override
  Widget build(BuildContext context) {
    return ListView(children: baseMenuElements);
  }

  Widget switchNoteNames() {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return ListTile(
          title: Text("Show Note Names"),
          trailing: Switch(
              value: settings.showNoteNames,
              onChanged: (value) {
                settings.showNoteNames = value;
              }),
        );
      },
    );
  }

  Widget rotateLabel() {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rotate_right),
            Text(
              " : Beat Pads",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PadsMenuContinuous extends PadsMenuTest {
  @override
  PadsMenuContinuous() {
    baseMenuElements.add(Text(""));
  }
}
