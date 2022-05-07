import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class IntSlider extends StatelessWidget {
  const IntSlider(
      {this.label = "#label",
      this.min = 0,
      this.max = 128,
      required this.setValue,
      required this.readValue,
      this.resetValue,
      Key? key})
      : super(key: key);

  final String label;
  final int min;
  final int max;
  final Function setValue;
  final int readValue;
  final Function? resetValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Row(
            children: [
              Text(label),
              if (resetValue != null)
                TextButton(
                  onPressed: () => resetValue!(),
                  child: Text("Reset"),
                )
            ],
          ),
          trailing: Text(readValue.toString()),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth * ThemeConst.sliderWidthFactor,
              child: Slider(
                min: min.toDouble(),
                max: max.toDouble(),
                value: readValue.toDouble(),
                onChanged: (value) {
                  setValue(value.toInt());
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
