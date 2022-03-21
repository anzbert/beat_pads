import 'package:beat_pads/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/services/pads_layouts.dart';

class DropdownLayout extends StatelessWidget {
  DropdownLayout({Key? key}) : super(key: key);

  final items = Layout.values
      .map((interval) =>
          DropdownMenuItem(child: Text(interval.name), value: interval))
      .toList();

//

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<Layout>(
        value: Provider.of<Settings>(context, listen: true).layout,
        items: items,
        onChanged: (value) {
          if (value != null) {
            Provider.of<Settings>(context, listen: false).layout = value;
          }
        },
      ),
    );
  }
}
