import 'package:beat_pads/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownNumbers extends StatelessWidget {
  DropdownNumbers({Key? key}) : super(key: key);

  final list = List<DropdownMenuItem<int>>.generate(
      8, (i) => DropdownMenuItem(child: Text("${i + 4}"), value: i + 4));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<int>(
        value: Provider.of<Settings>(context, listen: false).padDimensions[0],
        items: list,
        onChanged: (value) {
          if (value != null) {
            Provider.of<Settings>(context, listen: false).padDimensions[0] =
                value;
          }
        },
      ),
    );
  }
}
