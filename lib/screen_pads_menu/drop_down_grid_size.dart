import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/screen_home/_screen_home.dart';

enum Dimension { width, height }

class DropdownNumbers extends StatelessWidget {
  DropdownNumbers(this.dimension, {Key? key}) : super(key: key);

  final Dimension dimension;

  final list = List<DropdownMenuItem<int>>.generate(
      6, (i) => DropdownMenuItem(child: Text("${i + 3}"), value: i + 3));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<int>(
        value: dimension == Dimension.width
            ? Provider.of<Settings>(context, listen: true).width
            : Provider.of<Settings>(context, listen: true).height,
        items: list,
        onChanged: (value) {
          if (value != null) {
            if (dimension == Dimension.width) {
              Provider.of<Settings>(context, listen: false).width = value;
            } else if (dimension == Dimension.height) {
              Provider.of<Settings>(context, listen: false).height = value;
            }
          }
        },
      ),
    );
  }
}
