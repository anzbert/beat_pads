import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/services/_services.dart';

class DropdownPadLabels extends StatelessWidget {
  DropdownPadLabels({Key? key}) : super(key: key);

  final items = PadLabels.values
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
      child: DropdownButton<PadLabels>(
        value: Provider.of<Settings>(context, listen: true).padLabels,
        items: items,
        onChanged: (value) {
          if (value != null) {
            Provider.of<Settings>(context, listen: false).padLabels = value;
          }
        },
      ),
    );
  }
}
