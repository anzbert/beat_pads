import 'package:beat_pads/services/color_const.dart';
import 'package:beat_pads/state/settings.dart';
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
              ElevatedButton(
                onPressed: () {
                  settings.baseOctave++;
                },
                child: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  primary: Palette.cadetBlue.color,
                  onPrimary: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  settings.baseOctave--;
                },
                child: Icon(Icons.remove),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  primary: Palette.lightPink.color,
                  onPrimary: Colors.black,
                ),
              ),
            ]);
      },
    );
  }
}
