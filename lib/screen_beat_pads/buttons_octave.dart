import 'package:beat_pads/screen_home/model_settings.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OctaveButtons extends StatelessWidget {
  const OctaveButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<Settings>(context, listen: false).baseOctave++;
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(15),
            primary: Palette.cadetBlue.color,
            onPrimary: Palette.darkGrey.color,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<Settings>(context, listen: false).baseOctave++;
          },
          child: Icon(
            Icons.remove,
            size: 30,
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(15),
            primary: Palette.laserLemon.color,
            onPrimary: Palette.darkGrey.color,
          ),
        ),
      ],
    );
  }
}
