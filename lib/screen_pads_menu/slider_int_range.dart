import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class MidiRangeSelectorTile extends StatelessWidget {
  const MidiRangeSelectorTile({
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
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text("Reset"),
                ),
            ],
          ),
          trailing: Text("$readMin - $readMax"),
        ),
        Builder(
          builder: ((context) {
            double width = MediaQuery.of(context).size.width;
            return SizedBox(
              width: width * ThemeConst.sliderWidthFactor,
              child: RangeSlider(
                values: RangeValues(readMin.toDouble(), readMax.toDouble()),
                max: 128,
                labels: const RangeLabels(
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
