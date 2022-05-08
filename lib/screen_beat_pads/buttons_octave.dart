import 'package:beat_pads/services/model_variables.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/services/_services.dart';

class OctaveButtons extends StatelessWidget {
  const OctaveButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padSpacing = width * ThemeConst.padSpacingFactor;
    double padRadius = width * ThemeConst.padRadiusFactor;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(padRadius),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(padRadius),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
