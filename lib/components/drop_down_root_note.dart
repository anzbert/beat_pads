import 'package:flutter/material.dart';
import 'package:beat_pads/services/midi_utils.dart';

class DropdownRootNote extends StatelessWidget {
  const DropdownRootNote(
      {required this.setValue, required this.readValue, Key? key})
      : super(key: key);

  final Function setValue;
  final int readValue;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> menuItems = List.generate(
        12,
        (index) => DropdownMenuItem<int>(
              child: Text(getNoteName(index, showOctaveIndex: false)),
              value: index,
            ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<int>(
        value: readValue,
        items: menuItems.reversed.toList(),
        onChanged: (value) {
          setValue(value);
        },
      ),
    );
  }
}
