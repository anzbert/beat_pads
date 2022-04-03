import 'package:beat_pads/shared/_shared.dart';
import 'package:flutter/material.dart';

class IntCounter extends StatelessWidget {
  const IntCounter(
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
              child: Text("Reset"),
            ),
        ],
      ),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                setValue(readValue - 1);
              },
              child: Icon(Icons.remove),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                primary: Palette.laserLemon.color,
                onPrimary: Palette.darkGrey.color,
              ),
            ),
            Text(readValue.toString(),
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.titleMedium!.fontSize)),
            ElevatedButton(
              onPressed: () {
                setValue(readValue + 1);
              },
              child: Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                primary: Palette.cadetBlue.color,
                onPrimary: Palette.darkGrey.color,
              ),
            ),
          ]),
    );
  }
}
