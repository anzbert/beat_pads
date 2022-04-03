import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/screen_home/_screen_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OctaveButtons extends StatelessWidget {
  const OctaveButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  settings.baseOctave++;
                },
                child: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                  primary: Palette.cadetBlue.color,
                  onPrimary: Palette.darkGrey.color,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () {
                  settings.baseOctave--;
                },
                child: Icon(Icons.remove),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                  primary: Palette.laserLemon.color,
                  onPrimary: Palette.darkGrey.color,
                ),
              ),
            ]);
      },
    );
  }
}
