import 'package:beat_pads/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum RowInterval { minorThird, majorThird, quart, continuous }

class DropdownInterval extends StatelessWidget {
  DropdownInterval({Key? key}) : super(key: key);

  final items = RowInterval.values
      .map((interval) =>
          DropdownMenuItem(child: Text(interval.name), value: interval))
      .toList();

//

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<RowInterval>(
        value: Provider.of<Settings>(context, listen: true).rowInterval,
        items: items,
        onChanged: (value) {
          if (value != null) {
            Provider.of<Settings>(context, listen: false).rowInterval = value;
          }
        },
      ),
    );
  }
}
