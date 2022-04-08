import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/screen_home/_screen_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OctaveButtons extends StatelessWidget {
  const OctaveButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<Settings>(
      builder: (context, settings, child) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  settings.baseOctave++;
                },
                child: Icon(
                  Icons.add,
                  size: size.width * 0.05,
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(size.width * 0.02),
                  primary: Palette.cadetBlue.color,
                  onPrimary: Palette.darkGrey.color,
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              ElevatedButton(
                onPressed: () {
                  settings.baseOctave--;
                },
                child: Icon(
                  Icons.remove,
                  size: size.width * 0.05,
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(size.width * 0.02),
                  primary: Palette.laserLemon.color,
                  onPrimary: Palette.darkGrey.color,
                ),
              ),
            ]);
      },
    );
  }
}
