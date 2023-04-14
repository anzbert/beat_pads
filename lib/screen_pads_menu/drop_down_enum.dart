import 'package:flutter/material.dart';

class DropdownEnum<T extends Enum> extends StatelessWidget {
  const DropdownEnum({
    required this.values,
    required this.readValue,
    required this.setValue,
    super.key,
  });
  final T readValue;
  final void Function(T) setValue;
  final List<T> values;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<T>> dropList = values
        .map(
          (enumItem) => DropdownMenuItem(
            value: enumItem,
            child: Text(enumItem.toString()),
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
