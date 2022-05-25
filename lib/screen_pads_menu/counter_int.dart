import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';

class IntCounterTile extends StatelessWidget {
  const IntCounterTile(
      {this.label = "#label",
      required this.readValue,
      required this.setValue,
      this.resetFunction,
      Key? key})
      : super(key: key);

  final String label;
  final int readValue;
  final Function setValue;
  final Function? resetFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(label),
          if (resetFunction != null)
            TextButton(
              onPressed: () => resetFunction!(),
              child: const Text("Reset"),
            ),
        ],
      ),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (readValue - 1 >= 0) setValue(readValue - 1); // no negatives
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: Palette.laserLemon,
                onPrimary: Palette.darkGrey,
              ),
              child: const Icon(Icons.remove),
            ),
            Text(readValue.toString(),
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.titleMedium!.fontSize)),
            ElevatedButton(
              onPressed: () {
                setValue(readValue + 1);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: Palette.cadetBlue,
                onPrimary: Palette.darkGrey,
              ),
              child: const Icon(Icons.add),
            ),
          ]),
    );
  }
}
