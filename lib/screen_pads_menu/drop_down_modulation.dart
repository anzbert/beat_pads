import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class DropdownModulation extends StatelessWidget {
  final MPEmods? otherValue;
  final MPEmods readValue;
  final Dims? dimensions;
  final Function setValue;
  final List<DropdownMenuItem<MPEmods>> items;

  DropdownModulation(
      {required this.readValue,
      required this.setValue,
      this.otherValue,
      this.dimensions,
      Key? key})
      : items = MPEmods.values
            .where((modulation) {
              if (dimensions != null) {
                if (dimensions != modulation.dimensions) {
                  return false;
                }
              }
              return true;
            })
            .map(
              (modulation) =>
                  otherValue?.exclusiveGroup == modulation.exclusiveGroup &&
                          otherValue?.exclusiveGroup != Group.none
                      ? DropdownMenuItem<MPEmods>(
                          value: modulation,
                          enabled: false,
                          child: Text(modulation.title,
                              style: TextStyle(color: Palette.lightGrey)),
                        )
                      : DropdownMenuItem<MPEmods>(
                          value: modulation,
                          child: Text(modulation.title),
                        ),
            )
            .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<MPEmods>(
        value: readValue,
        items: items,
        onChanged: (MPEmods? value) {
          if (value != null) setValue(value);
        },
      ),
    );
  }
}
