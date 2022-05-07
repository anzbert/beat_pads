import 'package:flutter/material.dart';

class MidiRangeSelector extends StatelessWidget {
  const MidiRangeSelector({
    Key? key,
    this.label = "#Label",
    this.resetFunction,
    required this.readMin,
    required this.readMax,
    required this.setMin,
    required this.setMax,
    this.note = false,
  }) : super(key: key);

  final Function? resetFunction;
  final Function setMin;
  final Function setMax;
  final int readMin;
  final int readMax;
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
                ),
            ],
          ),
          trailing: Text("$readMin - $readMax"),
        ),
        LayoutBuilder(
          builder: ((context, constraints) {
            return SizedBox(
              width: constraints.maxWidth * 0.9,
              child: RangeSlider(
                values: RangeValues(readMin.toDouble(), readMax.toDouble()),
                max: 128,
                labels: RangeLabels(
                  "Min",
                  "Max",
                ),
                onChanged: (RangeValues values) {
                  setMin(values.start.toInt());
                  setMax(values.end.toInt());
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
