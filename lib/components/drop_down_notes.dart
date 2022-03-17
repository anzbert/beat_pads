import 'package:flutter/material.dart';
import 'package:beat_pads/services/midi_utils.dart';

class DropdownScaleNotes extends StatelessWidget {
  const DropdownScaleNotes(
      {this.scale,
      this.rootNote = 0,
      this.max,
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
  final int? max;
  final Function setValue;
  final int readValue;

  @override
  Widget build(BuildContext context) {
    final List<int> items;
    final List<DropdownMenuItem<int>> menuItems;

    if (scale == null) {
      items = getScaleArray(midiScales['chromatic']!, rootNote);
    } else {
      items = getScaleArray(midiScales[scale]!, rootNote);
    }
    if (max == null) {
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
    } else {
      menuItems = List.generate(
          max!,
          (e) => DropdownMenuItem<int>(
                child: Text(getNoteName(
                  e,
                  showOctaveIndex: showOctaveIndex,
                  showNoteValue: showNoteValue,
                )),
                value: e,
              )).toList();
    }

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
