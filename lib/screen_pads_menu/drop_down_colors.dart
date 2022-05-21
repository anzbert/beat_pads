import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/services/_services.dart';

class DropdownPadColors extends StatelessWidget {
  DropdownPadColors({Key? key}) : super(key: key);

  final items = PadColors.values
      .map(
        (colorSystem) => DropdownMenuItem(
          value: colorSystem,
          child: Text(colorSystem.title),
        ),
      )
      .toList();

//

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<PadColors>(
        value: Provider.of<Settings>(context, listen: true).padColors,
        items: items,
        onChanged: (value) {
          if (value != null) {
            Provider.of<Settings>(context, listen: false).padColors = value;
          }
        },
      ),
    );
  }
}
