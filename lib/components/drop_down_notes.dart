import 'package:flutter/material.dart';
import 'package:beat_pads/services/midi_utils.dart';

class DropdownScaleNotes extends StatelessWidget {
  const DropdownScaleNotes(
      {this.scale,
      required this.rootNote,
      this.showOctaveIndex = true,
      this.showNoteValue = false,
      required this.setValue,
      required this.readValue,
      Key? key})
      : super(key: key);

  final int rootNote;
  final bool showOctaveIndex;
  final bool showNoteValue;
  final String? scale;

  final Function setValue;
  final int readValue;

  @override
  Widget build(BuildContext context) {
    final List<int> items = allAbsoluteScaleNotes(midiScales[scale]!, rootNote);
    final List<DropdownMenuItem<int>> menuItems;

    menuItems = items
        .map((e) => DropdownMenuItem<int>(
              child: Text(getNoteName(
                e,
                showOctaveIndex: showOctaveIndex,
                showNoteValue: showNoteValue,
              )),
              value: e,
            ))
        .toList();

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
