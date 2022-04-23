import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/services/_services.dart';

class OctaveButtonsRect extends StatelessWidget {
  const OctaveButtonsRect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padSize = MediaQuery.of(context).size.width * 0.005;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSize, padSize, padSize),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<Settings>(context, listen: false).baseOctave++;
              },
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.add,
                  size: 100,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                primary: Palette.cadetBlue.color,
                onPrimary: Palette.darkGrey.color,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSize, padSize, padSize),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<Settings>(context, listen: false).baseOctave--;
              },
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.remove,
                  size: 100,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                primary: Palette.laserLemon.color,
                onPrimary: Palette.darkGrey.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
