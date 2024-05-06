import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class DropdownRootNote extends StatelessWidget {
  const DropdownRootNote({
    required this.setValue,
    required this.readValue,
    this.enabledList,
    super.key,
  });

  final void Function(int) setValue;
  final int readValue;
  final List<int>? enabledList;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<int>> menuItems = List.generate(12, (index) {
      bool enabled = enabledList == null ? true : enabledList!.contains(index);

      return DropdownMenuItem<int>(
        value: index,
        enabled: enabled,
        child: Text(
          MidiUtils.getNoteName(
            index,
            showOctaveIndex: false,
          ),
          style: enabled
              ? const TextStyle(fontWeight: FontWeight.bold)
              : TextStyle(color: Palette.darkGrey),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<int>(
        value: readValue,
        items: menuItems.toList(),
        onChanged: (int? value) {
          if (value != null) setValue(value);
        },
      ),
    );
  }
}
