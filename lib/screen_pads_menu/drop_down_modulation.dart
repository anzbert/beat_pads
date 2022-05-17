import 'package:beat_pads/services/_services.dart';
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
              (modulation) => DropdownMenuItem(
                value: modulation,
                enabled: modulation.exclusiveGroup == otherValue?.exclusiveGroup
                    ? false
                    : true,
                child: Text(modulation.title,
                    style:
                        modulation.exclusiveGroup == otherValue?.exclusiveGroup
                            ? TextStyle(color: Palette.lightGrey)
                            : null),
              ),
            )
            .toList(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<MPEmods>(
        value: readValue,
        items: items,
        onChanged: (value) {
          if (value != null) setValue(value);
        },
      ),
    );
  }
}
