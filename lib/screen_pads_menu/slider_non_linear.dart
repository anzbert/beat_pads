import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class NonLinearSliderTile extends StatelessWidget {
  const NonLinearSliderTile({
    this.label = "#Label",
    this.subtitle,
    this.resetFunction,
    required this.readValue,
    required this.setValue,
    this.actualValue,
    this.steps = 10,
    this.start = 0,
    Key? key,
  }) : super(key: key);

  final int steps;
  final int start;
  final Function? resetFunction;
  final Function setValue;
  final int readValue;
  final String label;
  final String? subtitle;
  final String? actualValue;

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
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: actualValue != null
              ? Text(actualValue!)
              : Text(readValue.toString()),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth * ThemeConst.sliderWidthFactor,
              child: Slider(
                min: start.toDouble(),
                max: steps.toDouble(),
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
