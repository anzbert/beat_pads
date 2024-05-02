import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class DropdownScaleNotes extends StatelessWidget {
  const DropdownScaleNotes({
    required this.rootNote,
    required this.setValue,
    required this.readValue,
    this.scale = Scale.chromatic,
    this.layout = Layout.majorThird,
    super.key,
  }) : usedScale = layout == Layout.scaleNotesOnly ? scale : Scale.chromatic;

  final Layout layout;
  final int rootNote;
  final Scale usedScale;
  final Scale scale;

  final void Function(int) setValue;
  final int readValue;

  @override
  Widget build(BuildContext context) {
    final List<int> items =
        MidiUtils.allAbsoluteScaleNotes(usedScale.intervals, rootNote);
    final List<DropdownMenuItem<int>> menuItems;

    menuItems = items
        .map(
          (note) => DropdownMenuItem<int>(
            value: note,
            child: Text(
              MidiUtils.getNoteName(
                note,
                showNoteValue: true,
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<int>(
        value: readValue,
        items: menuItems.reversed.toList(),
        onChanged: (newBase) {
          if (newBase != null) setValue(newBase);
        },
      ),
    );
  }
}
