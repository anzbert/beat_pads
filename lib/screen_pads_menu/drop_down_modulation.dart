import 'package:beat_pads/services/_temp_modulation.dart';
import 'package:flutter/material.dart';

class DropdownModulation extends StatelessWidget {
  DropdownModulation(
      {required this.readValue,
      required this.setValue,
      this.otherValue,
      this.includeCenter64 = true,
      Key? key})
      : items = MPEModulation.values
            .where((modulation) {
              if (otherValue == null) return true;
              if (modulation == otherValue) return false;
              if (modulation == MPEModulation.slide &&
                  otherValue == MPEModulation.slide64) return false;
              if (modulation == MPEModulation.slide64 &&
                  otherValue == MPEModulation.slide)
                return false; // TODO too much if and then
              return true;
            })
            .where((modulation) {
              if (includeCenter64) return true; // return all modulations
              return !modulation.center64;
            })
            .map(
              (modulation) => DropdownMenuItem(
                value: modulation,
                child: Text(modulation.title),
              ),
            )
            .toList(),
        super(key: key);

  final MPEModulation? otherValue;
  final MPEModulation readValue;
  final bool includeCenter64;
  final Function setValue;

  final List<DropdownMenuItem<MPEModulation>> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<MPEModulation>(
        value: readValue,
        items: items,
        onChanged: (value) {
          if (value != null) setValue(value);
        },
      ),
    );
  }
}
