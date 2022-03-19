import 'package:flutter/material.dart';
import '../services/midi_utils.dart';

class MidiValueSelector extends StatelessWidget {
  const MidiValueSelector({
    this.label = "#Label",
    this.resetFunction,
    required this.readValue,
    required this.setValue,
    this.note = false,
    this.min = 0,
    this.max = 128,
    Key? key,
  }) : super(key: key);

  final int min;
  final int max;
  final Function? resetFunction;
  final Function setValue;
  final int readValue;
  final String label;
  final bool note;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Row(
            children: [
              Text(label),
              if (resetFunction != null)
                TextButton(
                  onPressed: () => resetFunction!(),
                  child: Text("Reset"),
                )
            ],
          ),
          trailing: note
              ? Text("${getNoteName(readValue)}  (${readValue.toString()})")
              : Text(readValue.toString()),
        ),
        Slider(
          min: min.toDouble(),
          max: max.toDouble(),
          value: readValue.toDouble(),
          onChanged: (value) {
            setValue(value.toInt());
          },
        ),
      ],
    );
  }
}
