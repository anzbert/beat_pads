import 'package:flutter/material.dart';

enum Dimension { width, height }

class DropdownNumbers extends StatelessWidget {
  const DropdownNumbers(
      {this.min = 3,
      this.max = 9,
      required this.setValue,
      required this.readValue,
      Key? key})
      : super(key: key);

  final int min;
  final int max;
  final Function setValue;
  final int readValue;

  @override
  Widget build(BuildContext context) {
    final list = List<DropdownMenuItem<int>>.generate(
      max - min,
      (i) => DropdownMenuItem(
        value: i + min,
        child: Text(
          "${i + min}",
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<int>(
        value: readValue,
        items: list,
        onChanged: (value) {
          setValue(value);
        },
      ),
    );
  }
}
