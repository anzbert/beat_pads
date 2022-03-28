import 'package:beat_pads/components/pads_beat_pad_sustain.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beat_pads/state/settings.dart';

class VariablePads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<List<int>> rowsList =
        Provider.of<Settings>(context, listen: true).rowsLists;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
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
