import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class NonLinearSliderTile extends StatelessWidget {
  const NonLinearSliderTile({
    this.label = "#Label",
    this.subtitle,
    this.resetFunction,
    this.onChangeEnd,
    required this.readValue,
    required this.setValue,
    this.displayValue,
    this.steps = 100,
    this.start = 0,
    Key? key,
  }) : super(key: key);

  final int steps;
  final int start;
  final Function? resetFunction;
  final Function? onChangeEnd;
  final Function setValue;
  final int readValue;
  final String label;
  final String? subtitle;
  final String? displayValue;

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
                )
            ],
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: displayValue != null
              ? Text(displayValue!)
              : Text(readValue.toString()),
        ),
        Builder(
          builder: (context) {
            double width = MediaQuery.of(context).size.width;
            return SizedBox(
              width: width * ThemeConst.sliderWidthFactor,
              child: Slider(
                min: start.toDouble(),
                max: steps.toDouble(),
                value: readValue.clamp(start, steps).toDouble(),
                onChanged: (value) {
                  setValue(value.toInt());
                },
                onChangeEnd: (_) {
                  if (onChangeEnd != null) onChangeEnd!();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
