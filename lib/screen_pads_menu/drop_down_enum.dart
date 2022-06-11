import 'package:flutter/material.dart';

class DropdownEnum<T extends Enum> extends StatelessWidget {
  final T readValue;
  final Function setValue;
  final List<T> values;

  const DropdownEnum(
      {Key? key,
      required this.values,
      required this.readValue,
      required this.setValue})
      : super(key: key);

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<T>(
        value: readValue,
        items: dropList,
        onChanged: (v) {
          if (v != null) setValue(v);
        },
      ),
    );
  }
}
