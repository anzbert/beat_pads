import 'package:beat_pads/services/pads_layouts.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/services/midi_utils.dart';

class DropdownScaleNotes extends StatelessWidget {
  const DropdownScaleNotes(
      {this.scale = "chromatic",
      required this.rootNote,
      required this.setValue,
      required this.readValue,
      this.layout = Layout.continuous,
      Key? key})
      : usedScale = layout == Layout.scaleNotesOnly ? scale : "chromatic",
        super(key: key);

  final Layout layout;
  final int rootNote;
  final String usedScale;
  final String scale;

  final Function setValue;
  final int readValue;

  @override
  Widget build(BuildContext context) {
    final List<int> items =
        MidiUtils.allAbsoluteScaleNotes(midiScales[usedScale]!, rootNote);
    final List<DropdownMenuItem<int>> menuItems;

    menuItems = items
        .map((note) => DropdownMenuItem<int>(
              child: Text(MidiUtils.getNoteName(
                note,
                showOctaveIndex: true,
                showNoteValue: true,
              )),
              value: note,
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<int>(
        value: readValue,
        items: menuItems.reversed.toList(),
        onChanged: (newBase) {
          setValue(newBase);
        },
      ),
    );
  }
}
