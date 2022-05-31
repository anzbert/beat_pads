import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/services/services.dart';

class DropdownLayout extends StatelessWidget {
  DropdownLayout({Key? key}) : super(key: key);

  final items = Layout.values
      .map(
        (layout) => DropdownMenuItem(
          value: layout,
          child: Text(layout.title),
        ),
      )
      .toList();

//

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<Layout>(
        value: context.select((Settings settings) => settings.layout),
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
