import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class IntSliderTile extends StatelessWidget {
  const IntSliderTile(
      {this.label = "#label",
      this.subtitle,
      this.min = 0,
      this.max = 128,
      required this.setValue,
      required this.readValue,
      this.resetValue,
      required this.trailing,
      this.onChangeEnd,
      Key? key})
      : super(key: key);

  final Function? onChangeEnd;
  final String label;
  final String? subtitle;
  final int min;
  final int max;
  final Function setValue;
  final int readValue;
  final Function? resetValue;
  final Widget trailing;

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
          trailing: trailing,
        ),
        Builder(
          builder: (context) {
            double width = MediaQuery.of(context).size.width;
            return SizedBox(
              width: width * ThemeConst.sliderWidthFactor,
              child: Slider(
                min: min.toDouble(),
                max: max.toDouble(),
                value: readValue.clamp(min, max).toDouble(),
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
