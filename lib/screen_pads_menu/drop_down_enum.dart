import 'package:beat_pads/services/constants/const_colors.dart';
import 'package:flutter/material.dart';

class DropdownEnum<T extends Enum> extends StatelessWidget {
  const DropdownEnum({
    required this.values,
    required this.readValue,
    required this.setValue,
    this.filter,
    this.highlight,
    super.key,
  });
  final T readValue;
  final void Function(T) setValue;
  final List<T> values;
  final List<T>? highlight;
  final bool Function(T)? filter;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<T>> dropList = values
        .where((element) {
          if (filter == null) return true;
          return filter!(element);
        })
        .map(
          (enumItem) => DropdownMenuItem(
            value: enumItem,
            child: Text(
              enumItem.toString(),
              style: highlight == null
                  ? null
                  : highlight!.contains(enumItem)
                      ? TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Palette.yellowGreen,
                        )
                      : const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
            ),
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<T>(
        value: readValue,
        items: dropList,
        onChanged: (T? v) {
          if (v != null) setValue(v);
        },
      ),
    );
  }
}
