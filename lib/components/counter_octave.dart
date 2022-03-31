import 'package:beat_pads/services/color_const.dart';
import 'package:flutter/material.dart';

class BaseOctaveCounter extends StatelessWidget {
  const BaseOctaveCounter(
      {required this.readValue,
      required this.setValue,
      this.resetFunction,
      Key? key})
      : super(key: key);

  final int readValue;
  final Function setValue;
  final Function? resetFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text("Base Octave"),
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
                // padding: EdgeInsets.all(10),
                primary: Palette.laserLemon.color,
                onPrimary: Colors.black,
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
                // padding: EdgeInsets.all(10),
                primary: Palette.cadetBlue.color,
                onPrimary: Colors.black,
              ),
            ),
          ]),
    );
  }
}
