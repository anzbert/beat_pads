import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';

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
              value: index,
              child: Text(
                MidiUtils.getNoteName(
                  index,
                  showOctaveIndex: false,
                ),
              ),
            ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<int>(
        value: readValue,
        items: menuItems.toList(),
        onChanged: (value) {
          setValue(value);
        },
      ),
    );
  }
}
