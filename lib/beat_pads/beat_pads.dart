import 'package:beat_pads/beat_pads/pad_with_sustain.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/home/home.dart';

export 'package:beat_pads/beat_pads/buttons_octave.dart';
export 'package:beat_pads/beat_pads/button_lock_screen.dart';
export 'package:beat_pads/beat_pads/slider_pitch_bend.dart';

class VariablePads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<List<int>> rowsList =
        Provider.of<Settings>(context, listen: true).rowsLists;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...rowsList.map((row) {
              return Expanded(
                flex: 1,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...row.map((padNote) {
                        return Expanded(
                          flex: 1,
                          child: BeatPadSustain(
                            note: padNote,
                          ),
                        );
                      }).toList()
                    ]),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
